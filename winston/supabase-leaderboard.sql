-- Winston live leaderboard. Run once in Supabase: SQL Editor -> New query -> paste -> Run.
-- Design: the table has NO public policies, so nobody can read or write it directly.
-- The app talks to it only through the three functions below. Each person has a random
-- uid + secret stored in their browser; only the holder of the secret can update that row,
-- and you can only read rows for uids you were given (your friends' codes).

create table if not exists public.winston_scores (
  uid         uuid primary key,
  secret_hash text not null,
  name        text not null,
  dog         text not null,
  minutes     int  not null default 0,
  streak      int  not null default 0,
  level       int  not null default 1,
  updated_at  timestamptz not null default now()
);
alter table public.winston_scores enable row level security;   -- no policies on purpose

create or replace function public.winston_upsert(
  p_uid uuid, p_secret text, p_name text, p_dog text, p_minutes int, p_streak int, p_level int
) returns void language plpgsql security definer set search_path = public as $$
declare h text := encode(sha256(convert_to(p_secret, 'UTF8')), 'hex');
begin
  if length(p_secret) < 16 then raise exception 'secret too short'; end if;
  insert into winston_scores (uid, secret_hash, name, dog, minutes, streak, level, updated_at)
  values (p_uid, h, left(p_name, 40), left(p_dog, 40),
          greatest(0, least(p_minutes, 100000)), greatest(0, least(p_streak, 100000)), greatest(1, least(p_level, 1000)), now())
  on conflict (uid) do update
    set name = excluded.name, dog = excluded.dog, minutes = excluded.minutes,
        streak = excluded.streak, level = excluded.level, updated_at = now()
    where winston_scores.secret_hash = h;
  if not found then raise exception 'not allowed'; end if;
end $$;

create or replace function public.winston_board(p_uids uuid[])
returns table (uid uuid, name text, dog text, minutes int, streak int, level int, updated_at timestamptz)
language sql security definer set search_path = public as $$
  select uid, name, dog, minutes, streak, level, updated_at
  from winston_scores where uid = any (p_uids) limit 50;
$$;

create or replace function public.winston_delete(p_uid uuid, p_secret text)
returns void language sql security definer set search_path = public as $$
  delete from winston_scores
  where uid = p_uid and secret_hash = encode(sha256(convert_to(p_secret, 'UTF8')), 'hex');
$$;

grant execute on function public.winston_upsert(uuid, text, text, text, int, int, int) to anon, authenticated;
grant execute on function public.winston_board(uuid[])                                  to anon, authenticated;
grant execute on function public.winston_delete(uuid, text)                             to anon, authenticated;
