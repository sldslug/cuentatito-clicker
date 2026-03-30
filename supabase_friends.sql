-- Table des amis
create table public.friends (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  friend_id uuid references auth.users on delete cascade not null,
  status text default 'pending', -- pending, accepted
  created_at timestamp with time zone default now(),
  unique(user_id, friend_id)
);

alter table public.friends enable row level security;

create policy "Voir ses amis" on public.friends for select using (auth.uid() = user_id or auth.uid() = friend_id);
create policy "Ajouter un ami" on public.friends for insert with check (auth.uid() = user_id);
create policy "Accepter/refuser" on public.friends for update using (auth.uid() = friend_id or auth.uid() = user_id);
create policy "Supprimer ami" on public.friends for delete using (auth.uid() = user_id or auth.uid() = friend_id);

-- Presence en ligne (last_seen)
alter table public.profiles add column if not exists last_seen timestamp with time zone default now();
alter table public.profiles add column if not exists current_cuentas bigint default 0;
alter table public.profiles add column if not exists prestige_count int default 0;
alter table public.profiles add column if not exists total_earned bigint default 0;
