// Mappe un nom de parti tel qu'il apparaît sur Wikipédia vers l'une de nos
// 6 orientations fixes (jamais une 7e catégorie, pour ne pas faire
// disparaître silencieusement un parti de l'UI qui filtre par orientationId).
export const PARTY_ORIENTATIONS: Record<string, string> = {
  "Lutte ouvrière": "extreme-gauche",
  "Nouveau Parti anticapitaliste": "extreme-gauche",
  "La France insoumise": "extreme-gauche",
  "Parti socialiste (France)": "gauche",
  "Place publique (parti politique)": "gauche",
  "Parti communiste français": "gauche",
  "Les Écologistes": "gauche",
  "Génération.s": "gauche",
  "Renaissance (parti)": "centre",
  "Mouvement démocrate": "centre",
  "MoDem": "centre",
  "Horizons": "centre",
  "Parti radical": "centre",
  "Les Républicains": "droite",
  "Union des démocrates et indépendants": "droite",
  "Debout la France": "droite",
  "Union populaire républicaine (2007)": "extreme-droite",
  "Rassemblement national": "extreme-droite",
  "Reconquête (parti politique)": "extreme-droite",
  "Les Patriotes": "extreme-droite",
  "Union des droites pour la République": "droite",
};

export function orientationFor(partyWikiName: string): string {
  return PARTY_ORIENTATIONS[partyWikiName] ?? "sans-etiquette";
}

// Alias exacts (texte du lien Wikipédia) vers nos 9 partis curés
// auto-synchronisables. "modem" et "udr" sont volontairement absents :
// pas de correspondance déclarée actuellement, leurs fiches restent
// éditées à la main sans être touchées par la synchro.
export const CURATED_PARTY_ALIASES: Record<string, string> = {
  "La France insoumise": "lfi",
  "Place publique (parti politique)": "ps",
  "Les Écologistes": "ecologistes",
  "Parti communiste français": "pcf",
  "Renaissance (parti)": "renaissance",
  "Horizons": "horizons",
  "Les Républicains": "les-republicains",
  "Rassemblement national": "rn",
  "Reconquête (parti politique)": "reconquete",
};
