-- Table des partis/candidats, remplace la liste statique de lib/data/mock_data.dart.
-- is_curated = true : fiche écrite à la main (historique, représentation), jamais écrasée
-- par sync-parties sauf candidate_2027/candidate_image_url.
-- is_curated = false : fiche légère découverte automatiquement (voir supabase/functions/sync-parties).

create table if not exists parties (
  id text primary key,
  name text not null,
  orientation_id text not null,
  short_description text not null,
  leader text not null,
  leader_image_url text,
  candidate_2027 text,
  candidate_image_url text,
  key_figures text[],
  founded_year text,
  representation jsonb,
  history_summary text,
  history_roots text,
  history_details text,
  sources text[],
  is_curated boolean not null default false,
  updated_at timestamptz not null default now()
);

alter table parties enable row level security;
create policy "public read parties" on parties for select using (true);

alter publication supabase_realtime add table parties;

insert into parties (
  id, name, orientation_id, short_description, leader, leader_image_url, candidate_2027,
  key_figures, founded_year, representation, history_summary, history_roots, history_details, sources, is_curated
) values
(
  'lfi', 'La France insoumise', 'extreme-gauche',
  'Mouvement de gauche radicale fondé par Jean-Luc Mélenchon.',
  'Jean-Luc Mélenchon (fondateur), Manuel Bompard (coordinateur)',
  'https://upload.wikimedia.org/wikipedia/commons/8/88/JLM_EP_2016_%28cropped%29.jpg',
  'Jean-Luc Mélenchon',
  array['Jean-Luc Mélenchon', 'Manuel Bompard', 'Mathilde Panot'], '2016',
  '{"deputies":71,"senators":0,"euroDeputies":9,"deptPresidents":0,"regPresidents":0,"largeCityMayors":0}',
  'La France insoumise est un mouvement de gauche fondé en 2016 par Jean-Luc Mélenchon. Il défend une VIe République, une rupture avec le capitalisme financier et une écologie de rupture. Son classement politique (gauche radicale ou extrême gauche) fait débat parmi les politologues.',
  'LFI naît en 2016 dans la continuité du Parti de Gauche, lui-même fondé en 2008 par Jean-Luc Mélenchon après sa scission du Parti Socialiste. Le mouvement s''inscrit dans la tradition de la gauche républicaine et socialiste française, tout en s''en démarquant par un positionnement plus radical.',
  'Le mouvement se structure autour de la campagne présidentielle de 2017, où Jean-Luc Mélenchon obtient environ 19,6% des voix au premier tour. LFI défend un programme articulé autour de « L''Avenir en Commun » : planification écologique, revalorisation du smic, sortie des traités européens jugés contraignants, VIe République. Le mouvement devient la première force de gauche à l''Assemblée nationale après les législatives de 2022 et 2024. Il a connu plusieurs tensions internes et départs (notamment vers le mouvement L''Après en 2024).',
  array['Wikipédia', 'Site officiel LFI', 'Vie-publique.fr'], true
),
(
  'ps', 'Parti Socialiste', 'gauche',
  'Parti historique de la gauche française, social-démocrate.',
  'Olivier Faure',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGqThpJt6rkQSfJLb7CzgwWiWbbVstzHjcnXY0raY-jAXFgsBiB_ROw1lzJ8EmpoYpO_75zcA8w1WtCN1iFdxjKJvwC3mkwaB7HqV2Nope&s=10',
  'Raphaël Glucksmann (désigné par la primaire socialiste)',
  array['Olivier Faure', 'Raphaël Glucksmann'], '1969',
  '{"deputies":66,"senators":64,"euroDeputies":13,"deptPresidents":21,"regPresidents":5,"largeCityMayors":42}',
  'Le Parti Socialiste est le parti historique de la gauche de gouvernement en France, dirigé par Olivier Faure depuis 2018. Après une forte perte d''influence dans les années 2010, il amorce une reconstruction en s''alliant notamment avec Place Publique.',
  'Fondé en 1969 au congrès d''Issy-les-Moulineaux à partir de la SFIO (Section Française de l''Internationale Ouvrière), le PS prend sa forme moderne en 1971 au congrès d''Épinay sous l''impulsion de François Mitterrand.',
  'Le PS domine la gauche française pendant plusieurs décennies, portant François Mitterrand (1981, 1988) puis François Hollande (2012) à la présidence. Il connaît un net recul électoral après le quinquennat Hollande, tombant sous la barre des 10% en 2017. Ces dernières années, le parti amorce un début de reconstruction, notamment via une alliance avec Place Publique de Raphaël Glucksmann aux élections européennes de 2024.',
  array['Wikipédia', 'Site officiel du PS', 'Vie-publique.fr'], true
),
(
  'ecologistes', 'Les Écologistes (EELV)', 'gauche',
  'Parti écologiste de gauche, ex-Europe Écologie Les Verts.',
  'Marine Tondelier',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKIqkyTQJuOrGmxOQJpr00z5sJtRz4xqLcQ8FndoU6UA&s=10',
  'Marine Tondelier',
  array['Marine Tondelier'], '1984',
  '{"deputies":38,"senators":16,"euroDeputies":5,"deptPresidents":0,"regPresidents":0,"largeCityMayors":9}',
  'Les Écologistes (anciennement Europe Écologie Les Verts) portent une écologie politique de gauche, combinant urgence climatique et justice sociale. Le parti est dirigé depuis 2022 par Marine Tondelier.',
  'Le mouvement trouve ses racines dans les luttes écologistes des années 1970 (mouvement antinucléaire notamment) et se structure en parti politique, Les Verts, en 1984.',
  'Le parti prend le nom d''Europe Écologie Les Verts en 2010 après une alliance électorale réussie. Il participe à des gouvernements de gauche (notamment sous François Hollande) et connaît des résultats variables selon les scrutins, avec un score notable en 2024.',
  array['Wikipédia', 'Site officiel Les Écologistes'], true
),
(
  'pcf', 'Parti Communiste Français', 'gauche',
  'Parti historique de la gauche ouvrière et républicaine.',
  'Fabien Roussel',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOTkIw1dUiXLWksRPzZlJusLjo8OXlUVb2r-rHqSo0KTrH-_KYCM4GleFiookG381IKyYUAPDE1THulTW0w-asrpPMGKsmeLztdTh3SChv&s=10',
  'Fabien Roussel',
  array['Fabien Roussel'], '1920',
  '{"deputies":9,"senators":14,"euroDeputies":0,"deptPresidents":0,"regPresidents":0,"largeCityMayors":3}',
  'Le PCF est un parti historique de la gauche française, ancré dans la tradition ouvrière et républicaine. Dirigé par Fabien Roussel, il défend un positionnement distinct de celui de LFI, notamment sur la laïcité et l''énergie nucléaire.',
  'Fondé en 1920 lors du congrès de Tours, à la suite d''une scission de la SFIO sur la question de l''adhésion à la Troisième Internationale.',
  'Le PCF fut un acteur majeur de la vie politique française tout au long du XXe siècle, notamment dans la Résistance et les gouvernements de la Libération. Son influence électorale décline fortement à partir des années 1980. Aujourd''hui, le parti défend une ligne se voulant distincte de LFI au sein de la gauche.',
  array['Wikipédia', 'Site officiel du PCF'], true
),
(
  'renaissance', 'Renaissance', 'centre',
  'Parti centriste fondé par Emmanuel Macron.',
  'Gabriel Attal',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwK3Av2izSUQRGL3mmRccm8-U_qHJTeTfPIAjuPrpvEWLpOg7WhTzSjBCJnUnKw-15ObqevsGczwv1hO0ieWodsx3e18_EqQSmFwOrK7Cm4Q&s=10',
  'Gabriel Attal',
  array['Emmanuel Macron', 'Gabriel Attal'], '2016',
  '{"deputies":99,"senators":24,"euroDeputies":13,"deptPresidents":2,"regPresidents":1,"largeCityMayors":12}',
  'Renaissance (ex-La République en Marche) est le parti central de la majorité présidentielle depuis 2017. Il défend une ligne libérale et pro-européenne, entre gauche et droite.',
  'Fondé en 2016 par Emmanuel Macron sous le nom « En Marche ! », en dehors des partis traditionnels de gauche et de droite.',
  'Le mouvement porte Emmanuel Macron à la présidence en 2017 puis en 2022, et obtient une majorité (relative à partir de 2022) à l''Assemblée nationale. Il prend le nom de Renaissance en 2022 et forme, avec le MoDem et Horizons, le socle de la coalition « Ensemble ». Le parti est aujourd''hui dirigé par Gabriel Attal.',
  array['Wikipédia', 'Site officiel Renaissance'], true
),
(
  'modem', 'MoDem', 'centre',
  'Parti centriste et démocrate-chrétien, allié de Renaissance.',
  'François Bayrou',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThbfiUDhwx3LvtN1YDgFd7rxL4Fq2tbvc4nJYzw9OslA&s',
  'Jean-Noël Barrot (pressenti)',
  array['François Bayrou'], '2007',
  '{"deputies":36,"senators":26,"euroDeputies":0,"deptPresidents":1,"regPresidents":0,"largeCityMayors":5}',
  'Le Mouvement Démocrate est un parti centriste historique, dirigé par François Bayrou, allié de la majorité présidentielle depuis 2017.',
  'Fondé en 2007 par François Bayrou après l''échec de l''UDF à la présidentielle, dans la tradition du centrisme et de la démocratie chrétienne française.',
  'Le MoDem participe à toutes les majorités présidentielles depuis 2017 aux côtés de Renaissance. François Bayrou a occupé la fonction de Premier ministre en 2024-2025.',
  array['Wikipédia', 'Site officiel du MoDem'], true
),
(
  'horizons', 'Horizons', 'centre',
  'Parti centriste fondé par Édouard Philippe, allié de la majorité.',
  'Édouard Philippe',
  'https://upload.wikimedia.org/wikipedia/commons/2/2a/%C3%89douard_Philippe_in_2020.jpg',
  'Édouard Philippe',
  array['Édouard Philippe'], '2021',
  '{"deputies":35,"senators":12,"euroDeputies":0,"deptPresidents":1,"regPresidents":0,"largeCityMayors":6}',
  'Horizons est un parti centriste fondé par Édouard Philippe, ancien Premier ministre d''Emmanuel Macron, allié de la majorité présidentielle depuis sa création.',
  'Fondé en octobre 2021 par Édouard Philippe, alors maire du Havre, pour peser au sein de la coalition présidentielle sans se fondre dans Renaissance.',
  'Horizons soutient les gouvernements Macron tout en gardant une ligne distincte, plus marquée à droite sur certains sujets (retraites, dette publique). Édouard Philippe a annoncé sa candidature à l''élection présidentielle de 2027.',
  array['Wikipédia', 'Site officiel Horizons'], true
),
(
  'les-republicains', 'Les Républicains', 'droite',
  'Parti de droite issu du gaullisme et du libéralisme.',
  'Bruno Retailleau',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlnn2kRIaWsU3UJBgBgXG8dbbwUU3G1JhzGroUhAf99A&s',
  'Bruno Retailleau',
  array['Bruno Retailleau', 'Laurent Wauquiez'], '2015',
  '{"deputies":47,"senators":132,"euroDeputies":6,"deptPresidents":38,"regPresidents":7,"largeCityMayors":58}',
  'Les Républicains sont le principal parti de la droite de gouvernement, héritier du gaullisme. Le parti défend une ligne conservatrice sur les valeurs et libérale sur l''économie.',
  'Fondé en 2015 sous l''impulsion de Nicolas Sarkozy, en remplacement de l''UMP (elle-même issue en 2002 du RPR fondé par Jacques Chirac en 1976).',
  'Héritier direct du RPR puis de l''UMP, le parti a fourni plusieurs présidents de la République (Jacques Chirac, Nicolas Sarkozy). Depuis 2017, LR connaît un fort recul électoral, mais reste influent au Sénat et dans les collectivités locales. Une partie de ses cadres (dont Éric Ciotti) ont fait scission en 2024 pour se rapprocher du RN.',
  array['Wikipédia', 'Site officiel LR'], true
),
(
  'udr', 'Union des droites pour la République (UDR)', 'droite',
  'Parti fondé par Éric Ciotti après sa rupture avec LR.',
  'Éric Ciotti',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqqx4YCoD0miXAaca_TU-mdcoBS6GcPQHI3u7ygfQTYQ&s=10',
  null,
  array['Éric Ciotti'], '2024',
  '{"deputies":16,"senators":0,"euroDeputies":0,"deptPresidents":0,"regPresidents":0,"largeCityMayors":0}',
  'L''UDR est un parti de droite fondé en 2024 par Éric Ciotti après son exclusion des Républicains, avec une ligne assumant des alliances avec le Rassemblement National.',
  'Né d''une scission des Républicains en 2024, après qu''Éric Ciotti a appelé à une alliance électorale avec le RN aux législatives anticipées de 2024.',
  'Le parti se positionne comme une passerelle entre la droite classique et l''extrême droite, en assumant des alliances électorales avec le RN, ce qui le distingue nettement de la ligne officielle des Républicains.',
  array['Wikipédia', 'Presse politique française'], true
),
(
  'rn', 'Rassemblement National', 'extreme-droite',
  'Premier parti à l''Assemblée nationale depuis 2024, ligne nationaliste.',
  'Jordan Bardella',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROt3Eb47oQiDFEJUavIz6YpHw8ef4YETS0pvTJpgQO5Q&s',
  'Marine Le Pen',
  array['Marine Le Pen', 'Jordan Bardella'], '1972',
  '{"deputies":126,"senators":3,"euroDeputies":30,"deptPresidents":0,"regPresidents":0,"largeCityMayors":3}',
  'Le Rassemblement National, ex-Front National, défend une ligne nationaliste sur l''immigration et souverainiste sur l''Europe. Il est devenu la première force à l''Assemblée nationale après les législatives de 2024.',
  'Fondé en 1972 sous le nom de Front National, à l''initiative notamment de Jean-Marie Le Pen, rassemblant plusieurs courants nationalistes.',
  'Longtemps marginalisé, le parti amorce une dynamique électorale forte à partir des années 2010 sous la présidence de Marine Le Pen, qui engage une stratégie de « dédiabolisation » et rebaptise le parti Rassemblement National en 2018. Marine Le Pen atteint le second tour de la présidentielle en 2017 et 2022. Sous la présidence de Jordan Bardella depuis 2022, le parti obtient le plus grand nombre de sièges à l''Assemblée nationale lors des législatives de 2024.',
  array['Wikipédia', 'Site officiel RN'], true
),
(
  'reconquete', 'Reconquête', 'extreme-droite',
  'Parti nationaliste fondé par Éric Zemmour.',
  'Éric Zemmour',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjBxqwB61-kXbLVdz6I3hxOKuNGTWbxftasNlxSScA5A&s=10',
  'Éric Zemmour',
  array['Éric Zemmour', 'Marion Maréchal'], '2021',
  '{"deputies":0,"senators":0,"euroDeputies":1,"deptPresidents":0,"regPresidents":0,"largeCityMayors":0}',
  'Reconquête est un parti d''extrême droite fondé par Éric Zemmour en 2021, avec une ligne axée sur l''identité nationale et une critique radicale de l''immigration.',
  'Fondé en décembre 2021 par le polémiste et essayiste Éric Zemmour, en vue de sa candidature à l''élection présidentielle de 2022.',
  'Éric Zemmour obtient environ 7% des voix à la présidentielle de 2022. Le parti connaît des tensions internes, notamment le départ de Marion Maréchal en 2024 pour rejoindre une liste commune avec le RN aux élections européennes.',
  array['Wikipédia', 'Site officiel Reconquête'], true
)
on conflict (id) do nothing;
