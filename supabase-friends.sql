-- Run this once in Supabase (SQL Editor -> New query -> paste -> Run), after supabase-setup.sql.
-- It adds usernames, friend requests, and view-only garden sharing.

create table if not exists public.profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  handle text not null unique check (handle ~ '^[a-z0-9_]{3,20}$'),
  created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
create policy "usernames are visible to signed-in users" on public.profiles for select to authenticated using (true);
create policy "create my username" on public.profiles for insert to authenticated with check (auth.uid() = user_id);
create policy "change my username" on public.profiles for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.friendships (
  id uuid primary key default gen_random_uuid(),
  requester uuid not null references auth.users (id) on delete cascade,
  addressee uuid not null references auth.users (id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'accepted')),
  created_at timestamptz not null default now(),
  check (requester <> addressee),
  unique (requester, addressee)
);
alter table public.friendships enable row level security;
create policy "see my friendships" on public.friendships for select to authenticated using (auth.uid() in (requester, addressee));
create policy "send a request" on public.friendships for insert to authenticated with check (auth.uid() = requester and status = 'pending');
create policy "accept a request" on public.friendships for update to authenticated using (auth.uid() = addressee) with check (auth.uid() = addressee);
create policy "remove a friendship" on public.friendships for delete to authenticated using (auth.uid() in (requester, addressee));

create table if not exists public.shared_gardens (
  id uuid primary key default gen_random_uuid(),
  owner uuid not null references auth.users (id) on delete cascade,
  name text not null,
  data jsonb not null,
  shared_with uuid[] not null default '{}',
  updated_at timestamptz not null default now()
);
alter table public.shared_gardens enable row level security;
create policy "owner and chosen friends can read" on public.shared_gardens for select to authenticated using (auth.uid() = owner or auth.uid() = any (shared_with));
create policy "owner shares" on public.shared_gardens for insert to authenticated with check (auth.uid() = owner);
create policy "owner updates" on public.shared_gardens for update to authenticated using (auth.uid() = owner) with check (auth.uid() = owner);
create policy "owner stops sharing" on public.shared_gardens for delete to authenticated using (auth.uid() = owner);
