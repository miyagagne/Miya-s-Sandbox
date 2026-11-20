-- Group study / class sessions for the Study Park. Run once in Supabase SQL Editor (after supabase-accounts.sql).
create table if not exists public.winston_rooms (
  code text primary key, host uuid not null references auth.users(id) on delete cascade,
  kind text not null default 'study' check (kind in ('study','class')),
  title text not null default '', minutes int not null default 25,
  started_at timestamptz not null default now()
);
create table if not exists public.winston_room_members (
  code text not null references public.winston_rooms(code) on delete cascade,
  uid uuid not null references auth.users(id) on delete cascade,
  status text not null default 'Studying', last_seen timestamptz not null default now(),
  primary key (code, uid)
);
alter table public.winston_rooms enable row level security;
alter table public.winston_room_members enable row level security; -- access only through the functions below

create or replace function public.winston_room_create(p_kind text, p_title text, p_minutes int) returns text
language plpgsql security definer set search_path=public as $$
declare c text; i int := 0;
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  loop
    c := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    exit when not exists (select 1 from winston_rooms where code = c); i := i + 1; exit when i > 20;
  end loop;
  insert into winston_rooms(code, host, kind, title, minutes) values (c, auth.uid(), case when p_kind='class' then 'class' else 'study' end, left(coalesce(p_title,''),60), greatest(5, least(coalesce(p_minutes,25), 240)));
  insert into winston_room_members(code, uid, status) values (c, auth.uid(), 'Studying');
  return c;
end $$;

create or replace function public.winston_room_join(p_code text, p_status text) returns jsonb
language plpgsql security definer set search_path=public as $$
declare r winston_rooms;
begin
  if auth.uid() is null then return null; end if;
  select * into r from winston_rooms where code = upper(trim(p_code));
  if not found then return null; end if;
  if now() > r.started_at + (r.minutes + 10) * interval '1 minute' then return null; end if;
  insert into winston_room_members(code, uid, status, last_seen) values (r.code, auth.uid(), left(coalesce(p_status,'Studying'),30), now())
    on conflict (code, uid) do update set status = excluded.status, last_seen = now();
  return jsonb_build_object('code', r.code, 'kind', r.kind, 'title', r.title, 'minutes', r.minutes, 'started_at', r.started_at);
end $$;

create or replace function public.winston_room_members(p_code text)
returns table(username text, name text, dog text, breed text, status text, e jsonb, me boolean)
language sql security definer set search_path=public as $$
  select p.username, p.data->'user'->>'name', p.data->'user'->>'dogName', p.data->'pet'->>'breed', m.status, p.stats->'e', (m.uid = auth.uid())
  from winston_room_members m join winston_profiles p on p.id = m.uid
  where m.code = upper(trim(p_code)) and m.last_seen > now() - interval '45 seconds'
    and exists (select 1 from winston_room_members x where x.code = m.code and x.uid = auth.uid())
  order by m.last_seen desc limit 30;
$$;

create or replace function public.winston_room_leave(p_code text) returns void
language sql security definer set search_path=public as $$
  delete from winston_room_members where code = upper(trim(p_code)) and uid = auth.uid();
$$;
grant execute on function public.winston_room_create(text,text,int), public.winston_room_join(text,text), public.winston_room_members(text), public.winston_room_leave(text) to authenticated;
