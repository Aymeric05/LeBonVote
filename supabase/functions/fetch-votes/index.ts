// Port de functions/index.js exports.fetchVotes (Firebase Cloud Function -> Supabase Edge Function).
// Planifiée une fois par jour via pg_cron (voir supabase/migrations/0002_cron.sql).
import { createClient } from "npm:@supabase/supabase-js@2";
import AdmZip from "npm:adm-zip@0.5";
import { Buffer } from "node:buffer";
import { GROUP_TO_PARTY } from "../_shared/parties.ts";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

Deno.serve(async () => {
  const url = "https://data.assemblee-nationale.fr/static/openData/repository/17/loi/scrutins/Scrutins.json.zip";
  const organesUrl = "https://data.assemblee-nationale.fr/static/openData/repository/17/amo/deputes_actifs_mandats_actifs_organes_divises/AMO40_deputes_actifs_mandats_actifs_organes_divises.json.zip";

  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`Erreur téléchargement Assemblée nationale: HTTP ${response.status}`);
    const buffer = Buffer.from(await response.arrayBuffer());
    const zip = new AdmZip(buffer);

    const organesResponse = await fetch(organesUrl);
    if (!organesResponse.ok) throw new Error(`Erreur téléchargement organes: HTTP ${organesResponse.status}`);
    const organesBuffer = Buffer.from(await organesResponse.arrayBuffer());
    const organesZip = new AdmZip(organesBuffer);

    // Mapping POxxxx -> informations du groupe.
    const groupesMap: Record<string, { nom: string; abreviation: string | null }> = {};

    for (const entry of organesZip.getEntries()) {
      if (entry.isDirectory || !entry.entryName.startsWith("organe/") || !entry.entryName.endsWith(".json")) continue;
      try {
        const data = JSON.parse(entry.getData().toString("utf8"));
        const organe = data.organe;
        if (organe?.codeType === "GP") {
          groupesMap[organe.uid] = {
            nom: organe.libelle,
            abreviation: organe.libelleAbrev || organe.libelleAbrege || null,
          };
        }
      } catch (err) {
        console.error(`Erreur organe ${entry.entryName}:`, (err as Error).message);
      }
    }

    const jsonEntries = zip.getEntries().filter(
      (entry) => !entry.isDirectory && entry.entryName.startsWith("json/") && entry.entryName.endsWith(".json"),
    );

    const parsedScrutins: any[] = [];
    for (const entry of jsonEntries) {
      try {
        const data = JSON.parse(entry.getData().toString("utf8"));
        if (!data.scrutin) continue;
        parsedScrutins.push(data.scrutin);
      } catch (err) {
        console.error(`Erreur lecture ${entry.entryName}:`, (err as Error).message);
      }
    }

    parsedScrutins.sort((a, b) => {
      const dateComparison = new Date(b.dateScrutin).getTime() - new Date(a.dateScrutin).getTime();
      if (dateComparison !== 0) return dateComparison;
      return Number(b.numero) - Number(a.numero);
    });

    // Pour commencer, on ne stocke que les 20 scrutins les plus récents.
    const recentScrutins = parsedScrutins.slice(0, 20);

    for (const scrutin of recentScrutins) {
      const groupesRaw = scrutin.ventilationVotes?.organe?.groupes?.groupe || [];
      const groupesArray = Array.isArray(groupesRaw) ? groupesRaw : [groupesRaw];

      const groupes = groupesArray.map((groupe: any) => {
        const voix = groupe.vote?.decompteVoix || {};
        const infosGroupe = groupesMap[groupe.organeRef];
        const abreviation = infosGroupe?.abreviation || null;

        return {
          organeRef: groupe.organeRef || null,
          nom: infosGroupe?.nom || "Groupe inconnu",
          abreviation,
          partyId: (abreviation && GROUP_TO_PARTY[abreviation]) || null,
          nombreMembres: Number(groupe.nombreMembresGroupe || 0),
          positionMajoritaire: groupe.vote?.positionMajoritaire || null,
          pour: Number(voix.pour || 0),
          contre: Number(voix.contre || 0),
          abstentions: Number(voix.abstentions || 0),
          nonVotants: Number(voix.nonVotants || 0),
          nonVotantsVolontaires: Number(voix.nonVotantsVolontaires || 0),
        };
      });

      const synthese = scrutin.syntheseVote || {};
      const decompte = synthese.decompte || {};

      const { error } = await supabase.from("votes").upsert({
        numero: Number(scrutin.numero),
        uid: scrutin.uid,
        legislature: Number(scrutin.legislature),
        date: scrutin.dateScrutin,
        titre: scrutin.titre || scrutin.objet?.libelle || "Scrutin sans titre",
        objet: scrutin.objet?.libelle || null,
        dossier_legislatif: scrutin.objet?.dossierLegislatif?.libelle || null,
        dossier_ref: scrutin.objet?.dossierLegislatif?.dossierRef || null,
        type_vote: scrutin.typeVote?.libelleTypeVote || null,
        resultat: scrutin.sort?.code || null,
        resultat_libelle: scrutin.sort?.libelle || null,
        synthese: {
          nombreVotants: Number(synthese.nombreVotants || 0),
          suffragesExprimes: Number(synthese.suffragesExprimes || 0),
          suffragesRequis: Number(synthese.nbrSuffragesRequis || 0),
          pour: Number(decompte.pour || 0),
          contre: Number(decompte.contre || 0),
          abstentions: Number(decompte.abstentions || 0),
          nonVotants: Number(decompte.nonVotants || 0),
        },
        groupes,
        source: "Assemblée nationale",
        fetched_at: new Date().toISOString(),
      }, { onConflict: "numero" });

      if (error) console.error(`Échec upsert scrutin ${scrutin.numero}:`, error.message);
    }

    return new Response(`Terminé : ${recentScrutins.length} scrutins mis à jour`);
  } catch (err) {
    console.error("[fetch-votes] ERREUR :", err);
    return new Response(`Erreur: ${(err as Error).message}`, { status: 500 });
  }
});
