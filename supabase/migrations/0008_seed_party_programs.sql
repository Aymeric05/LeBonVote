-- Positions idéologiques durables des partis curés (registre encyclopédique,
-- comme l'onglet Histoire), et non des promesses de campagne 2027 non encore
-- publiées à la date d'écriture (l'élection a lieu en 2027).
update parties set program_summary =
  'Rupture avec le capitalisme financier et planification écologique : retraite à 60 ans, hausse du smic, encadrement des loyers et des prix de l''énergie, VIe République par une assemblée constituante, sortie des traités européens jugés trop contraignants, règle verte limitant les prélèvements sur les ressources naturelles.'
  where id = 'lfi';

update parties set program_summary =
  'Social-démocratie réformiste : renforcement des services publics (santé, éducation), fiscalité plus progressive, transition écologique planifiée avec l''État, défense du modèle social français, ancrage pro-européen avec une Europe plus sociale et plus protectrice.'
  where id = 'ps';

update parties set program_summary =
  'Écologie politique conjuguée à la justice sociale : sortie des énergies fossiles et du nucléaire à terme, investissement massif dans les renouvelables et la rénovation thermique, revenu minimum garanti, décentralisation et démocratie participative renforcée.'
  where id = 'ecologistes';

update parties set program_summary =
  'Défense de la condition ouvrière et des services publics : nationalisations ciblées dans l''énergie et les transports, augmentation des salaires, attachement à la laïcité et à l''énergie nucléaire civile, ligne distincte de LFI au sein de la gauche.'
  where id = 'pcf';

update parties set program_summary =
  'Libéralisme pro-européen et pro-entreprise : poursuite des réformes du marché du travail et des retraites, investissement dans l''innovation et la réindustrialisation, souveraineté européenne renforcée en matière de défense et de technologie, ligne centriste entre gauche et droite.'
  where id = 'renaissance';

update parties set program_summary =
  'Centrisme pragmatique, humaniste et pro-européen, proche des positions du MoDem et de Renaissance au sein de la majorité : priorité à l''éducation, à la ruralité et à l''équilibre des finances publiques, avec une ligne plus marquée à droite sur la dette et les retraites.'
  where id = 'horizons';

update parties set program_summary =
  'Démocratie chrétienne et centrisme pro-européen : priorité à l''éducation et à la formation, finances publiques maîtrisées, ruralité et aménagement du territoire, soutien constant aux majorités présidentielles depuis 2017.'
  where id = 'modem';

update parties set program_summary =
  'Droite conservatrice et libérale : baisse des dépenses publiques et des impôts, fermeté sur l''immigration et la sécurité, défense de l''identité nationale et des valeurs républicaines, soutien à l''énergie nucléaire et à l''agriculture française.'
  where id = 'les-republicains';

update parties set program_summary =
  'Droite assumant des alliances électorales avec le Rassemblement National : ligne proche de celle des Républicains sur l''immigration, la sécurité et la fiscalité, avec une volonté explicite de rassembler les droites plutôt que de les diviser.'
  where id = 'udr';

update parties set program_summary =
  'Nationalisme et souverainisme : priorité nationale et réduction drastique de l''immigration, sortie de certains cadres européens jugés contraignants, protectionnisme économique, référendums d''initiative citoyenne, ligne devenue dominante à l''Assemblée nationale depuis 2024.'
  where id = 'rn';

update parties set program_summary =
  'Nationalisme identitaire radical : remigration et arrêt quasi total de l''immigration, défense de « l''identité et la civilisation françaises », ligne plus dure que le RN sur l''immigration et l''islam, libéralisme économique assumé.'
  where id = 'reconquete';
