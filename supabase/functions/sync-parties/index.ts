import { createClient } from "jsr:@supabase/supabase-js@2";
import { CURATED_PARTY_ALIASES, orientationFor } from "../_shared/party-orientations.ts";

const WIKI_PAGE = "Candidatures à l'élection présidentielle française de 2027";
const WIKI_URL = `https://fr.wikipedia.org/w/index.php?title=${encodeURIComponent(WIKI_PAGE)}&action=raw`;

const GENERIC_LABELS = new Set([
  "indépendant",
  "candidat indépendant",
  "sans étiquette",
  "sans parti",
  "non-inscrit",
  "divers",
]);

function slugify(name: string): string {
  return name
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function displayName(wikiName: string): string {
  return wikiName.replace(/\s*\([^)]*\)\s*$/, "").trim();
}

function commonsFileUrl(filename: string): string {
  return `https://commons.wikimedia.org/wiki/Special:FilePath/${encodeURIComponent(filename.trim())}`;
}

function isGenericLabel(wikiName: string): boolean {
  return GENERIC_LABELS.has(displayName(wikiName).toLowerCase());
}

interface Candidate {
  name: string;
  partyWikiName: string;
  photoUrl: string | null;
}

function parseDeclaredCandidates(wikitext: string): Candidate[] {
  const start = wikitext.indexOf("== Candidats déclarés ==");
  const end = wikitext.indexOf("== Candidats pressentis ==");
  const section = start >= 0 ? wikitext.slice(start, end >= 0 ? end : undefined) : wikitext;

  const headerRegex = /^!\s*(?:\{\{TriNom\|([^|}]+)\|([^|}]+)\}\}|\[\[([^\]|]+)\]\])/gm;
  const headers: { index: number; name: string }[] = [];
  let m: RegExpExecArray | null;
  while ((m = headerRegex.exec(section)) !== null) {
    const name = m[3] ?? `${m[1]} ${m[2]}`;
    headers.push({ index: m.index, name: name.trim() });
  }

  const candidates: Candidate[] = [];
  for (let i = 0; i < headers.length; i++) {
    const windowStart = headers[i].index;
    const windowEnd = i + 1 < headers.length ? headers[i + 1].index : section.length;
    const windowText = section.slice(windowStart, Math.min(windowEnd, windowStart + 2000));

    const ageIdx = windowText.indexOf("{{Âge|");
    const afterAge = ageIdx >= 0 ? windowText.slice(ageIdx) : windowText;
    const partyMatch = afterAge.match(/<br\s*\/?>\s*\[\[([^\]|]+)/);

    const photoMatch = windowText.match(/\[\[Fichier:([^|\]]+)/);

    candidates.push({
      name: headers[i].name,
      partyWikiName: partyMatch ? partyMatch[1].trim() : "Indépendant",
      photoUrl: photoMatch ? commonsFileUrl(photoMatch[1]) : null,
    });
  }
  return candidates;
}

Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const response = await fetch(WIKI_URL, {
    headers: { "User-Agent": "LeBonVoteApp/1.0 (Supabase Edge Function; sync-parties)" },
  });
  const wikitext = await response.text();

  const candidates = parseDeclaredCandidates(wikitext);
  const curatedAlreadyUpdated = new Set<string>();
  let updated = 0;
  let inserted = 0;

  for (const candidate of candidates) {
    const curatedId = CURATED_PARTY_ALIASES[candidate.partyWikiName];

    if (curatedId) {
      if (curatedAlreadyUpdated.has(curatedId)) continue;
      curatedAlreadyUpdated.add(curatedId);
      const { error } = await supabase
        .from("parties")
        .update({
          candidate_2027: candidate.name,
          candidate_image_url: candidate.photoUrl,
          updated_at: new Date().toISOString(),
        })
        .eq("id", curatedId);
      if (!error) updated++;
      continue;
    }

    const generic = isGenericLabel(candidate.partyWikiName);
    const id = generic ? slugify(candidate.name) : slugify(candidate.partyWikiName);
    const name = generic ? candidate.name : displayName(candidate.partyWikiName);

    const { error } = await supabase.from("parties").upsert({
      id,
      name,
      orientation_id: generic ? "sans-etiquette" : orientationFor(candidate.partyWikiName),
      short_description: "Candidat déclaré à l'élection présidentielle de 2027.",
      leader: candidate.name,
      candidate_2027: candidate.name,
      candidate_image_url: candidate.photoUrl,
      is_curated: false,
      sources: [`https://fr.wikipedia.org/wiki/${encodeURIComponent(WIKI_PAGE)}`],
      updated_at: new Date().toISOString(),
    });
    if (!error) inserted++;
  }

  return new Response(
    `${candidates.length} candidats trouvés, ${updated} fiches curées mises à jour, ${inserted} partis découverts upsertés.`,
  );
});
