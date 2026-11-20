-- Winston accounts + cloud sync. Run once in Supabase: SQL Editor -> New query -> paste -> Run.
-- Then: Authentication -> Providers -> Email (enabled). Optional: turn OFF "Confirm email" for instant sign-up.
-- For "Continue with Google": Authentication -> Providers -> Google -> enable, paste your Google OAuth Client ID + Secret,
-- and add https://odsrrlaxhyqfkxtxynep.supabase.co/auth/v1/callback as an Authorized redirect URI in Google Cloud.
-- Authentication -> URL Configuration -> add https://miyagagne.github.io/Miya-s-Sandbox/winston/ to Redirect URLs.

create table if not exists public.winston_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
create unique index if not exists winston_profiles_username_key on public.winston_profiles (lower(username)) where username is not null;
alter table public.winston_profiles enable row level security;
drop policy if exists "own profile read"   on public.winston_profiles;
drop policy if exists "own profile insert" on public.winston_profiles;
drop policy if exists "own profile update" on public.winston_profiles;
drop policy if exists "own profile delete" on public.winston_profiles;
create policy "own profile read"   on public.winston_profiles for select using (auth.uid() = id);
create policy "own profile insert" on public.winston_profiles for insert with check (auth.uid() = id);
create policy "own profile update" on public.winston_profiles for update using (auth.uid() = id) with check (auth.uid() = id);
create policy "own profile delete" on public.winston_profiles for delete using (auth.uid() = id);

-- Is this username free? (callable before sign-up; reveals nothing else)
create or replace function public.winston_username_free(p_username text) returns boolean
language sql security definer set search_path = public as $$
  select not exists (select 1 from public.winston_profiles where lower(username) = lower(p_username));
$$;
grant execute on function public.winston_username_free(text) to anon, authenticated;

-- Let a signed-in user delete their own account and data.
create or replace function public.winston_delete_account() returns void
language plpgsql security definer set search_path = public, auth as $$
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  delete from auth.users where id = auth.uid();
end;
$$;
grant execute on function public.winston_delete_account() to authenticated;
