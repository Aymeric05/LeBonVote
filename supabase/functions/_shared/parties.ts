export const PARTIES = [
  { id: "rn", name: "Rassemblement National", query: "Rassemblement National", matchTerms: ["rassemblement national", " rn "] },
  { id: "renaissance", name: "Renaissance", query: "Renaissance Macron parti", matchTerms: ["renaissance"] },
  { id: "les-republicains", name: "Les Républicains", query: "Les Républicains parti", matchTerms: ["les républicains", " lr "] },
  { id: "lfi", name: "La France insoumise", query: "La France insoumise", matchTerms: ["france insoumise", " lfi "] },
  { id: "ps", name: "Parti Socialiste", query: "Parti Socialiste France", matchTerms: ["parti socialiste", " ps "] },
  { id: "ecologistes", name: "Les Écologistes", query: "Europe Écologie Les Verts", matchTerms: ["écologistes", "eelv", "europe écologie"] },
  { id: "pcf", name: "Parti Communiste Français", query: "Parti Communiste Français", matchTerms: ["parti communiste", " pcf "] },
  { id: "modem", name: "MoDem", query: "MoDem Bayrou", matchTerms: ["modem", "mouvement démocrate"] },
  { id: "udr", name: "UDR", query: "Éric Ciotti UDR", matchTerms: [" udr ", "éric ciotti"] },
  { id: "reconquete", name: "Reconquête", query: "Reconquête Zemmour", matchTerms: ["reconquête"] },
];

export const GROUP_TO_PARTY: Record<string, string> = {
  RN: "rn",
  LFI: "lfi",
  SOC: "ps",
  EcoS: "ecologistes",
  DR: "les-republicains",
  DEM: "modem",
  EPR: "renaissance",
  UDR: "udr",
};

// Normalise un texte : minuscules, sans accents, entouré d'espaces pour matcher les mots isolés.
export function normalize(text: string): string {
  return " " + text
    .toLowerCase()
    .normalize("NFD").replace(/[̀-ͯ]/g, "")
    + " ";
}

export function isRelevantToParty(
  article: { title?: string; description?: string },
  party: { matchTerms: string[] },
): boolean {
  const haystack = normalize((article.title || "") + " " + (article.description || ""));
  return party.matchTerms.some((term) => haystack.includes(normalize(term).trim()));
}

// Découpe un titre en mots significatifs (ignore les mots courts/accents).
export function significantWords(title: string): string[] {
  return normalize(title)
    .replace(/[^a-z0-9\s]/g, "")
    .split(/\s+/)
    .filter((w) => w.length > 3);
}

// Similarité de Jaccard entre deux listes de mots (0 = rien en commun, 1 = identique).
export function similarity(wordsA: string[], wordsB: string[]): number {
  const setA = new Set(wordsA);
  const setB = new Set(wordsB);
  const intersection = [...setA].filter((w) => setB.has(w));
  const union = new Set([...setA, ...setB]);
  return union.size === 0 ? 0 : intersection.length / union.size;
}
