import 'party_representation.dart';

// Modèle représentant un parti politique, avec ses infos de base
// et son contenu pour la rubrique "Histoire".
// Les champs éditoriaux (historique, représentation...) sont nullable : les
// partis découverts automatiquement par supabase/functions/sync-parties n'en
// ont pas tous, contrairement aux fiches écrites à la main (is_curated=true
// côté base, voir supabase/migrations/0003_parties.sql).
class Party {
  final String id; // identifiant unique, ex: "rassemblement-national"
  final String name; // nom du parti
  final String orientationId; // lien vers PoliticalOrientation.id
  final String shortDescription; // phrase courte affichée sur la carte
  final String leader; // dirigeant actuel
  final String? leaderImageUrl; // tête du dirigeant actuel
  final String? candidate2027; // candidat déclaré/pressenti à la présidentielle 2027 (si distinct du leader)
  final String? candidateImageUrl; // photo du candidat 2027 (distincte du dirigeant du parti)
  final List<String> keyFigures; // personnalités importantes
  final String? foundedYear; // année de création
  final PartyRepresentation? representation; // données de poids politique, absentes pour les partis découverts auto

  // --- Contenu de l'onglet "Histoire" (absent pour les partis non curés) ---
  final String? historySummary; // résumé en 3-4 lignes : parti + idées
  final String? historyRoots; // racines / origine du parti
  final String? historyDetails; // histoire détaillée, idées, évolution
  final List<String> sources; // sources citées pour cette fiche

  const Party({
    required this.id,
    required this.name,
    required this.orientationId,
    required this.shortDescription,
    this.leaderImageUrl,
    required this.leader,
    this.candidate2027,
    this.candidateImageUrl,
    this.keyFigures = const [],
    this.foundedYear,
    this.representation,
    this.historySummary,
    this.historyRoots,
    this.historyDetails,
    this.sources = const [],
  });

  factory Party.fromMap(Map<String, dynamic> map) {
    final representationMap = map['representation'] as Map<String, dynamic>?;
    return Party(
      id: map['id'] as String,
      name: map['name'] as String,
      orientationId: map['orientation_id'] as String,
      shortDescription: map['short_description'] as String,
      leader: map['leader'] as String,
      leaderImageUrl: map['leader_image_url'] as String?,
      candidate2027: map['candidate_2027'] as String?,
      candidateImageUrl: map['candidate_image_url'] as String?,
      keyFigures: (map['key_figures'] as List?)?.cast<String>() ?? const [],
      foundedYear: map['founded_year'] as String?,
      representation: representationMap == null ? null : PartyRepresentation.fromMap(representationMap),
      historySummary: map['history_summary'] as String?,
      historyRoots: map['history_roots'] as String?,
      historyDetails: map['history_details'] as String?,
      sources: (map['sources'] as List?)?.cast<String>() ?? const [],
    );
  }
}
