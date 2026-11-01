-- Les 4 jobs n'avaient pas de timeout_milliseconds explicite, donc net.http_post
-- utilisait le défaut (5000ms). Les fonctions (appels externes : Currents API,
-- scraping Wikipédia, décompression de fichiers) dépassent souvent ce délai,
-- ce qui faisait échouer les cron jobs en silence même avec des secrets valides.
select cron.alter_job(
  (select jobid from cron.job where jobname = 'fetch-party-news'),
  command => $$
  select net.http_post(
    url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/fetch-party-news',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key'),
      'Content-Type', 'application/json'
    ),
    timeout_milliseconds := 60000
  );
  $$
);

select cron.alter_job(
  (select jobid from cron.job where jobname = 'fetch-votes'),
  command => $$
  select net.http_post(
    url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/fetch-votes',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key'),
      'Content-Type', 'application/json'
    ),
    timeout_milliseconds := 60000
  );
  $$
);

select cron.alter_job(
  (select jobid from cron.job where jobname = 'build-news-clusters'),
  command => $$
  select net.http_post(
    url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/build-news-clusters',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key'),
      'Content-Type', 'application/json'
    ),
    timeout_milliseconds := 60000
  );
  $$
);

select cron.alter_job(
  (select jobid from cron.job where jobname = 'sync-parties'),
  command => $$
  select net.http_post(
    url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/sync-parties',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key'),
      'Content-Type', 'application/json'
    ),
    timeout_milliseconds := 60000
  );
  $$
);
