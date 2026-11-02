import { createClient } from "jsr:@supabase/supabase-js@2";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

// Titres de section Wikipédia où un programme/des propositions sont en général
// décrits. On prend la première section qui matche.
const PROGRAM_HEADING_RE =
  /^(={2,4})\s*(programme(?:\s+électoral)?|propositions?|positions?\s+politiques?|projet\s+politique)\s*={2,4}\s*$/im;

function cleanWikitext(raw: string): string {
  return raw
    .replace(/<ref[^>]*\/>/gi, "")
    .replace(/<ref[^>]*>[\s\S]*?<\/ref>/gi, "")
    .replace(/\[\[(?:Fichier|File|Image):[^\]]*\]\]/gi, "") // images/légendes, pas du texte lisible
    .replace(/\{\{[^{}]*\}\}/g, "") // templates simples (non imbriqués)
    .replace(/\[\[(?:[^\]|]*\|)*([^\]]+)\]\]/g, "$1") // [[cible|...|texte]] ou [[cible]] -> dernier segment
    .replace(/'''?'?/g, "")
    .replace(/<[^>]+>/g, "")
    .replace(/^=+\s*.*?\s*=+$/gm, "") // titres de sous-section résiduels
    .replace(/^\*+\s*/gm, "• ")
    .replace(/[ \t]{2,}/g, " ")
    .replace(/\n{2,}/g, "\n")
    .trim();
}

function extractProgramSection(wikitext: string): string | null {
  const match = wikitext.match(PROGRAM_HEADING_RE);
  if (!match || match.index === undefined) return null;

  const headingLevel = match[1].length;
  const sectionStart = match.index + match[0].length;
  const nextHeadingRe = new RegExp(`^={2,${headingLevel}}[^=].*={2,${headingLevel}}\\s*$`, "m");
  const rest = wikitext.slice(sectionStart);
  const nextMatch = rest.match(nextHeadingRe);
  const sectionEnd = nextMatch?.index !== undefined ? nextMatch.index : rest.length;

  const cleaned = cleanWikitext(rest.slice(0, sectionEnd));
  if (cleaned.length < 80) return null; // trop court pour être un vrai contenu

  if (cleaned.length <= 900) return cleaned;
  const truncated = cleaned.slice(0, 900);
  const lastSentenceEnd = Math.max(truncated.lastIndexOf(". "), truncated.lastIndexOf(".\n"));
  return (lastSentenceEnd > 400 ? truncated.slice(0, lastSentenceEnd + 1) : truncated) + "…";
}

Deno.serve(async () => {
  const { data: candidates, error: readError } = await supabase
    .from("parties")
    .select("id, wiki_page_title")
    .is("program_summary", null)
    .not("wiki_page_title", "is", null);

  if (readError) {
    return new Response(`Erreur lecture: ${readError.message}`, { status: 500 });
  }

  let found = 0;
  let checked = 0;

  for (const party of candidates ?? []) {
    checked++;
    const url = `https://fr.wikipedia.org/w/index.php?title=${encodeURIComponent(party.wiki_page_title as string)}&action=raw`;

    try {
      const response = await fetch(url, {
        headers: { "User-Agent": "LeBonVoteApp/1.0 (Supabase Edge Function; sync-party-programs)" },
      });
      if (!response.ok) continue;

      const wikitext = await response.text();
      const program = extractProgramSection(wikitext);
      if (!program) continue;

      const { error } = await supabase
        .from("parties")
        .update({ program_summary: program, updated_at: new Date().toISOString() })
        .eq("id", party.id);
      if (!error) found++;
    } catch (err) {
      console.error(`Échec récupération programme pour ${party.id}:`, (err as Error).message);
    }
  }

  return new Response(`${checked} partis vérifiés, ${found} programmes trouvés et ajoutés.`);
});
