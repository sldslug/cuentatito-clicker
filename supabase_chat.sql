create table public.chat_messages (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  username text not null,
  message text not null,
  prestige_count int default 0,
  created_at timestamp with time zone default now()
);

alter table public.chat_messages enable row level security;

create policy "Lecture publique chat" on public.chat_messages for select using (true);
create policy "Envoyer message" on public.chat_messages for insert with check (auth.uid() = user_id);
