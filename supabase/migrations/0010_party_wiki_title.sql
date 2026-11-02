-- Titre exact de la page Wikipédia à utiliser pour tenter d'extraire un
-- programme automatiquement (voir supabase/functions/sync-party-programs).
alter table parties add column if not exists wiki_page_title text;

update parties set wiki_page_title =
  case id
    when 'lfi' then 'La France insoumise'
    when 'ps' then 'Parti socialiste (France)'
    when 'ecologistes' then 'Les Écologistes'
    when 'pcf' then 'Parti communiste français'
    when 'renaissance' then 'Renaissance (parti)'
    when 'modem' then 'Mouvement démocrate'
    when 'horizons' then 'Horizons (parti)'
    when 'les-republicains' then 'Les Républicains'
    when 'udr' then 'Union des droites pour la République'
    when 'rn' then 'Rassemblement national'
    when 'reconquete' then 'Reconquête'
  end
where is_curated = true;
