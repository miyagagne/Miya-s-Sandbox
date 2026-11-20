-- Winston friend requests by username. Run once in Supabase SQL Editor (after supabase-accounts.sql).
alter table public.winston_profiles add column if not exists stats jsonb not null default '{}'::jsonb;
create table if not exists public.winston_friend_requests (
  id bigserial primary key,
  from_id uuid not null references auth.users(id) on delete cascade,
  to_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','accepted','declined')),
  created_at timestamptz not null default now(),
  unique (from_id, to_id)
);
alter table public.winston_friend_requests enable row level security; -- no direct access, only the functions below

create or replace function public.winston_find_user(p_q text)
returns table(username text, name text, dog text, breed text)
language sql security definer set search_path=public as $$
  select p.username, p.data->'user'->>'name', p.data->'user'->>'dogName', p.data->'pet'->>'breed'
  from winston_profiles p
  where auth.uid() is not null and length(trim(p_q)) >= 3 and p.id <> auth.uid() and p.username is not null
    and lower(p.username) like lower(replace(replace(trim(p_q),'%',''),'_','\_')) || '%'
  order by (lower(p.username)=lower(trim(p_q))) desc, p.username limit 8;
$$;

create or replace function public.winston_friend_request(p_username text) returns text
language plpgsql security definer set search_path=public as $$
declare t uuid; r record;
begin
  if auth.uid() is null then return 'signin'; end if;
  select id into t from winston_profiles where lower(username)=lower(trim(p_username));
  if t is null then return 'notfound'; end if;
  if t = auth.uid() then return 'self'; end if;
  select * into r from winston_friend_requests where (from_id=auth.uid() and to_id=t) or (from_id=t and to_id=auth.uid()) order by id desc limit 1;
  if found then
    if r.status='accepted' then return 'friends'; end if;
    if r.status='pending' and r.from_id=t then update winston_friend_requests set status='accepted' where id=r.id; return 'accepted'; end if;
    if r.status='pending' then return 'sent'; end if;
    if r.from_id=auth.uid() then return 'declined'; end if;
  end if;
  insert into winston_friend_requests(from_id,to_id) values(auth.uid(),t) on conflict do nothing;
  return 'sent';
end $$;

create or replace function public.winston_friend_inbox()
returns table(id bigint, username text, name text, dog text, breed text, direction text)
language sql security definer set search_path=public as $$
  select r.id, p.username, p.data->'user'->>'name', p.data->'user'->>'dogName', p.data->'pet'->>'breed',
         case when r.to_id=auth.uid() then 'in' else 'out' end
  from winston_friend_requests r
  join winston_profiles p on p.id = case when r.to_id=auth.uid() then r.from_id else r.to_id end
  where r.status='pending' and (r.to_id=auth.uid() or r.from_id=auth.uid()) order by r.created_at desc;
$$;

create or replace function public.winston_friend_respond(p_id bigint, p_accept boolean) returns void
language sql security definer set search_path=public as $$
  update winston_friend_requests set status = case when p_accept then 'accepted' else 'declined' end
  where id=p_id and to_id=auth.uid() and status='pending';
$$;

create or replace function public.winston_friend_list()
returns table(username text, name text, dog text, stats jsonb)
language sql security definer set search_path=public as $$
  select p.username, p.data->'user'->>'name', p.data->'user'->>'dogName', p.stats
  from winston_friend_requests r
  join winston_profiles p on p.id = case when r.to_id=auth.uid() then r.from_id else r.to_id end
  where r.status='accepted' and (r.to_id=auth.uid() or r.from_id=auth.uid());
$$;

create or replace function public.winston_friend_remove(p_username text) returns void
language sql security definer set search_path=public as $$
  delete from winston_friend_requests where status in ('accepted','pending') and
   ((from_id=auth.uid() and to_id=(select id from winston_profiles where lower(username)=lower(p_username)))
 or (to_id=auth.uid() and from_id=(select id from winston_profiles where lower(username)=lower(p_username))));
$$;

grant execute on function public.winston_find_user(text), public.winston_friend_request(text), public.winston_friend_inbox(),
  public.winston_friend_respond(bigint,boolean), public.winston_friend_list(), public.winston_friend_remove(text) to authenticated;
