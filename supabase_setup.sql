-- Table des profils joueurs (liée à auth.users)
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique not null,
  created_at timestamp with time zone default now()
);

-- Table des sauvegardes
create table public.saves (
  id uuid references auth.users on delete cascade primary key,
  data jsonb not null default '{}',
  updated_at timestamp with time zone default now()
);

-- Table du classement
create table public.scores (
  id uuid references auth.users on delete cascade primary key,
  username text not null,
  total_earned bigint default 0,
  prestige_count int default 0,
  total_clics bigint default 0,
  diamonds int default 0,
  updated_at timestamp with time zone default now()
);

-- Activer RLS (Row Level Security)
alter table public.profiles enable row level security;
alter table public.saves enable row level security;
alter table public.scores enable row level security;

-- Policies profiles
create policy "Lecture publique des profils" on public.profiles for select using (true);
create policy "Insertion son propre profil" on public.profiles for insert with check (auth.uid() = id);
create policy "Modification son propre profil" on public.profiles for update using (auth.uid() = id);

-- Policies saves
create policy "Lecture sa propre save" on public.saves for select using (auth.uid() = id);
create policy "Insertion sa propre save" on public.saves for insert with check (auth.uid() = id);
create policy "Modification sa propre save" on public.saves for update using (auth.uid() = id);

-- Policies scores
create policy "Lecture publique des scores" on public.scores for select using (true);
create policy "Insertion son propre score" on public.scores for insert with check (auth.uid() = id);
create policy "Modification son propre score" on public.scores for update using (auth.uid() = id);
