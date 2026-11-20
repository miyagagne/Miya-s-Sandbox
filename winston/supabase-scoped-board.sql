-- Winston scoped leaderboard (school / state / country). Run once in Supabase SQL Editor.
create table if not exists public.winston_public (
  uid text primary key, secret text not null,
  name text, dog text, minutes int default 0, streak int default 0, level int default 1,
  school text, state text, country text, updated_at timestamptz default now()
);
alter table public.winston_public enable row level security;  -- no direct access; only via the functions below
create or replace function public.winston_scope_upsert(p_uid text,p_secret text,p_name text,p_dog text,p_minutes int,p_streak int,p_level int,p_school text,p_state text,p_country text) returns void
language plpgsql security definer set search_path=public as $$
begin
  insert into winston_public(uid,secret,name,dog,minutes,streak,level,school,state,country,updated_at)
  values(p_uid,p_secret,left(p_name,30),left(p_dog,20),p_minutes,p_streak,p_level,lower(left(p_school,80)),lower(left(p_state,40)),lower(left(p_country,40)),now())
  on conflict(uid) do update set name=excluded.name,dog=excluded.dog,minutes=excluded.minutes,streak=excluded.streak,level=excluded.level,school=excluded.school,state=excluded.state,country=excluded.country,updated_at=now()
  where winston_public.secret=p_secret;
end $$;
create or replace function public.winston_scope_board(p_field text,p_value text) returns table(uid text,name text,dog text,minutes int,streak int,level int)
language plpgsql security definer set search_path=public as $$
begin
  if p_field not in ('school','state','country') then raise exception 'bad field'; end if;
  return query execute format('select uid,name,dog,minutes,streak,level from winston_public where %I = lower($1) and updated_at > now() - interval ''14 days'' order by minutes desc limit 50',p_field) using p_value;
end $$;
grant execute on function public.winston_scope_upsert(text,text,text,text,int,int,int,text,text,text) to anon,authenticated;
grant execute on function public.winston_scope_board(text,text) to anon,authenticated;
