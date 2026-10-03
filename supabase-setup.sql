-- Run this once in Supabase: SQL Editor -> New query -> paste -> Run.
create table if not exists public.gardens (
  user_id uuid primary key references auth.users (id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.gardens enable row level security;

-- Each signed-in person can only see and change their own garden.
create policy "read own garden"   on public.gardens for select using (auth.uid() = user_id);
create policy "insert own garden" on public.gardens for insert with check (auth.uid() = user_id);
create policy "update own garden" on public.gardens for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "delete own garden" on public.gardens for delete using (auth.uid() = user_id);
