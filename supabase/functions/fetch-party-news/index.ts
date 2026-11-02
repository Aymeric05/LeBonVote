// Port de functions/index.js exports.fetchPartyNews (Firebase Cloud Function -> Supabase Edge Function).
// Planifiée toutes les 6h via pg_cron (voir supabase/migrations/0002_cron.sql).
import { createClient } from "npm:@supabase/supabase-js@2";
import { PARTIES, isRelevantToParty } from "../_shared/parties.ts";
import { sendPartyPush } from "../_shared/onesignal.ts";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

interface NewsParty {
  id: string;
  name: string;
  query: string;
  matchTerms: string[];
}

async function fetchNewsForParty(party: NewsParty, apiKey: string | undefined) {
  const url = `https://api.currentsapi.services/v1/search?keywords=${encodeURIComponent(party.query)}&language=fr&apiKey=${apiKey}`;

  try {
    const response = await fetch(url);
    const rawText = await response.text();

    // Nettoyage manuel des caractères corrompus les plus fréquents si nécessaire.
    const cleanText = rawText
      .replace(/Ã©/g, "é")
      .replace(/Ã /g, "à")
      .replace(/Ã¨/g, "è")
      .replace(/Ã¹/g, "ù")
      .replace(/Ã»/g, "û")
      .replace(/Ãª/g, "ê")
      .replace(/Ã®/g, "î")
      .replace(/Ã´/g, "ô")
      .replace(/â\u0080\u0099/g, "'")
      .replace(/â\u0080¦/g, "...");

    const data = JSON.parse(cleanText);

    if (data.status !== "ok") {
      console.error(`Erreur Currents API pour ${party.id}:`, JSON.stringify(data));
      return;
    }

    for (const article of data.news) {
      if (!isRelevantToParty(article, party)) continue;

      // ignoreDuplicates + select() : seules les lignes réellement insérées (pas les
      // doublons déjà connus) reviennent dans `inserted`, ce qui sert à ne pousser une
      // notif que pour les vrais nouveaux articles.
      const { data: inserted, error } = await supabase.from("news").upsert({
        url: article.url,
        party_id: party.id,
        title: article.title,
        description: article.description || "",
        source_name: article.author || "Source inconnue",
        published_at: article.published ? new Date(article.published).toISOString() : new Date().toISOString(),
        fetched_at: new Date().toISOString(),
      }, { onConflict: "url", ignoreDuplicates: true }).select();

      if (error) {
        console.error(`Échec upsert news pour ${party.id}:`, error.message);
      } else if (inserted && inserted.length > 0) {
        await sendPartyPush(party.id, party.name, article.title, article.url);
      }
    }
  } catch (err) {
    console.error(`Échec de récupération pour ${party.id}:`, (err as Error).message);
  }
}

Deno.serve(async () => {
  const apiKey = Deno.env.get("CURRENTS_API_KEY");

  // Partis curés : requêtes et termes de recherche réglés à la main, traités
  // en premier pour garantir leur couverture même si le quota API est atteint.
  for (const party of PARTIES) {
    await fetchNewsForParty(party, apiKey);
  }

  // Partis découverts automatiquement (sync-parties) : recherchés par nom du
  // candidat (plus trouvable dans la presse que le nom d'un petit parti), pour
  // que ceux qui n'ont jamais eu de couverture dédiée en aient une aussi.
  const { data: discoveredParties } = await supabase
    .from("parties")
    .select("id, name, candidate_2027")
    .eq("is_curated", false);

  for (const row of discoveredParties ?? []) {
    const searchName = row.candidate_2027 || row.name;
    await fetchNewsForParty(
      { id: row.id, name: row.name, query: searchName, matchTerms: [searchName] },
      apiKey,
    );
  }

  return new Response("Récupération des actualités terminée.");
});
