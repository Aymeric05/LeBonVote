import '../models/political_orientation.dart';
import '../theme/app_theme.dart';

class MockData {
  static const List<PoliticalOrientation> orientations = [
    PoliticalOrientation(
      id: 'extreme-gauche',
      name: 'Extrême gauche',
      description: 'Courants anticapitalistes et révolutionnaires',
      color: AppTheme.extremeGauche,
      summary:
      "L'extrême gauche porte une critique radicale du capitalisme et prône une "
          "transformation profonde, voire révolutionnaire, de la société et de l'économie.",
      longDescription:
      "L'extrême gauche regroupe des courants qui portent une critique radicale du système "
          "capitaliste et prônent une transformation profonde, voire révolutionnaire, de la société "
          "et de l'économie. On y trouve des traditions marxistes, trotskistes ou anarchistes, qui "
          "défendent la collectivisation des moyens de production et une rupture nette avec "
          "l'ordre économique libéral. Le classement précis de certains partis (comme LFI) dans "
          "cette catégorie ou dans la « gauche radicale » fait débat parmi les politologues.",
      sources: ['Wikipédia — Extrême gauche', 'CEVIPOF (Sciences Po)'],
    ),
    PoliticalOrientation(
      id: 'gauche',
      name: 'Gauche',
      description: 'Courants sociaux-démocrates et écologistes',
      color: AppTheme.gauche,
      summary:
      "La gauche défend l'égalité sociale et la redistribution des richesses, avec un rôle "
          "fort de l'État pour protéger les travailleurs et réduire les inégalités.",
      longDescription:
      "La gauche regroupe des courants politiques qui privilégient l'égalité sociale, la "
          "redistribution des richesses et l'intervention de l'État dans l'économie. Elle défend "
          "historiquement les droits des travailleurs, la protection sociale (santé, retraites, "
          "chômage) et, plus récemment, une forte attention portée à l'écologie et aux questions "
          "sociétales (droits des minorités, égalité femmes-hommes). Elle s'oppose généralement "
          "aux logiques de dérégulation économique et défend un rôle actif de la puissance "
          "publique pour corriger les inégalités produites par le marché.",
      sources: ['Vie-publique.fr', 'Wikipédia — Gauche (politique)'],
    ),
    PoliticalOrientation(
      id: 'centre',
      name: 'Centre',
      description: 'Courants centristes et libéraux',
      color: AppTheme.centre,
      summary:
      "Le centre cherche un équilibre entre régulation sociale et libéralisme économique, "
          "en misant sur le dialogue, le pragmatisme et l'ancrage européen.",
      longDescription:
      "Le centre rassemble des courants qui se positionnent entre la gauche et la droite, "
          "cherchant un équilibre entre régulation sociale et libéralisme économique. Il défend "
          "souvent le dialogue social, le pragmatisme sur les réformes économiques, et un fort "
          "attachement à la construction européenne. Les partis centristes s'allient historiquement "
          "tantôt avec la gauche, tantôt avec la droite, selon les contextes électoraux.",
      sources: ['Vie-publique.fr', 'Wikipédia — Centrisme'],
    ),
    PoliticalOrientation(
      id: 'droite',
      name: 'Droite',
      description: 'Courants conservateurs et libéraux-conservateurs',
      color: AppTheme.droite,
      summary:
      "La droite privilégie la liberté individuelle et économique, un État plus restreint, "
          "et une ligne ferme sur l'ordre, la sécurité et l'identité nationale.",
      longDescription:
      "La droite regroupe des courants qui privilégient la liberté individuelle et "
          "économique, un État plus restreint dans l'économie, et l'attachement à l'ordre, à la "
          "sécurité et aux traditions. Elle défend généralement la baisse des impôts et des "
          "dépenses publiques, la valorisation du mérite individuel et de l'initiative privée, "
          "ainsi qu'une ligne plus ferme sur les questions d'immigration et de sécurité que la "
          "gauche.",
      sources: ['Vie-publique.fr', 'Wikipédia — Droite (politique)'],
    ),
    PoliticalOrientation(
      id: 'extreme-droite',
      name: 'Extrême droite',
      description: 'Courants nationalistes',
      color: AppTheme.extremeDroite,
      summary:
      "L'extrême droite place l'identité nationale au cœur de son projet, avec une ligne "
          "très restrictive sur l'immigration et une critique forte de l'Union européenne.",
      longDescription:
      "L'extrême droite regroupe des courants nationalistes qui placent l'identité nationale "
          "au cœur de leur projet politique, avec une ligne très restrictive sur l'immigration et "
          "une critique forte des institutions supranationales comme l'Union européenne. Ces "
          "partis défendent généralement une vision autoritaire de l'ordre et de la sécurité, et "
          "mettent en avant la préférence nationale dans l'accès à certains droits sociaux.",
      sources: ['Wikipédia — Extrême droite', 'CEVIPOF (Sciences Po)'],
    ),
    PoliticalOrientation(
      id: 'sans-etiquette',
      name: 'Sans étiquette',
      description: 'Partis divers ou non classés',
      color: AppTheme.sansEtiquette,
      summary:
      "Cette catégorie rassemble les candidats et petites formations qui ne se rattachent à "
          "aucune grande famille politique nationale ou au clivage gauche-droite classique.",
      longDescription:
      "Cette catégorie regroupe les candidats et petites formations qui ne se rattachent à "
          "aucune des grandes familles politiques nationales, ou dont le positionnement ne "
          "correspond pas clairement au clivage gauche-droite traditionnel. Elle inclut aussi des "
          "listes purement locales ou des candidatures individuelles.",
      sources: ["Ministère de l'Intérieur"],
    ),
  ];
}