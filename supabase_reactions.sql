create table public.global_events (
  id uuid default gen_random_uuid() primary key,
  username text not null,
  type text not null, -- 'prestige', 'record', 'milestone'
  data jsonb default '{}',
  created_at timestamp with time zone default now()
);

alter table public.global_events enable row level security;
create policy "Lecture publique" on public.global_events for select using (true);
create policy "Insertion authentifie" on public.global_events for insert with check (auth.uid() is not null);
