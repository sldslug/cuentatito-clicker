-- Table des événements admin
create table public.admin_events (
  id uuid default gen_random_uuid() primary key,
  type text not null, -- 'boss', 'bonus', 'notification', 'code'
  data jsonb not null default '{}',
  active boolean default true,
  created_at timestamp with time zone default now(),
  expires_at timestamp with time zone
);

alter table public.admin_events enable row level security;

-- Tout le monde peut lire les événements actifs
create policy "Lecture publique events" on public.admin_events for select using (true);

-- Seul Sluginho peut créer/modifier/supprimer
create policy "Admin insert" on public.admin_events for insert with check (
  (select username from public.profiles where id = auth.uid()) = 'Sluginho'
);
create policy "Admin update" on public.admin_events for update using (
  (select username from public.profiles where id = auth.uid()) = 'Sluginho'
);
create policy "Admin delete" on public.admin_events for delete using (
  (select username from public.profiles where id = auth.uid()) = 'Sluginho'
);
