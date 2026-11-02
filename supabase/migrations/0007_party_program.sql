-- Résumé du programme/positions du parti, affiché comme info majeure sur
-- sa fiche. Nullable : absent pour les partis découverts automatiquement
-- (sync-parties) tant que personne ne l'a renseigné à la main.
alter table parties add column if not exists program_summary text;
