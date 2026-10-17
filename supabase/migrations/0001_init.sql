-- Schéma initial LeBonVote : remplace les collections Firestore votes/news/newsClusters/config.
-- Les ID en MD5 de Firestore sont remplacés par des contraintes unique naturelles (url, numero).

create table if not exists votes (
  numero int primary key,
  uid text,
  legislature int,
  date text,
  titre text,
  objet text,
  dossier_legislatif text,
  dossier_ref text,
  type_vote text,
  resultat text,
  resultat_libelle text,
  synthese jsonb,
  groupes jsonb,
  source text,
  fetched_at timestamptz not null default now()
);

create table if not exists news (
  id uuid primary key default gen_random_uuid(),
  url text not null unique,
  party_id text,
  title text,
  description text,
  source_name text,
  published_at timestamptz,
  fetched_at timestamptz not null default now()
);
create index if not exists news_party_id_idx on news (party_id);
create index if not exists news_published_at_idx on news (published_at);

create table if not exists news_clusters (
  id uuid primary key default gen_random_uuid(),
  main_url text not null unique,
  title text,
  description text,
  published_at timestamptz,
  source_count int,
  sources jsonb,
  fetched_at timestamptz not null default now()
);

create table if not exists config (
  id text primary key,
  data jsonb not null default '{}'::jsonb
);

alter table votes enable row level security;
alter table news enable row level security;
alter table news_clusters enable row level security;
alter table config enable row level security;

create policy "public read votes" on votes for select using (true);
create policy "public read news" on news for select using (true);
create policy "public read news_clusters" on news_clusters for select using (true);
create policy "public read config" on config for select using (true);

-- Remplit la config pubs par défaut (équivalent au doc config/ads de Firestore, à ajuster dans le SQL editor si besoin).
insert into config (id, data) values ('ads', '{"showRealAds": false, "androidBannerId": null}'::jsonb)
on conflict (id) do nothing;

-- L'app Flutter utilise .stream() (Realtime) sur ces 3 tables, il faut les publier.
alter publication supabase_realtime add table votes, news, news_clusters;
