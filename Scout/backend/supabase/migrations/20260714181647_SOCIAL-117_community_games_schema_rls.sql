-- Jira: SOCIAL-117
-- Tech Plan: implementation/proposed/EVENT-002-community-games-v1.md
-- Purpose: Create Community Games V1 event and participant tables with RLS.
-- Affected Area: Supabase
-- RLS Impact: Adds organizer, participant, and visible-event access boundaries.
-- Generated Types: Updated in this PR because CI validates generated type freshness.
-- Rollback: Forward-fix with a follow-up migration unless review identifies a safe local-only reset.

create table public.community_games (
  id uuid primary key default gen_random_uuid(),
  organizer_profile_id uuid not null references public.profiles (id) on delete cascade,
  sport_slug text not null,
  title text not null,
  description text,
  lifecycle_state text not null default 'draft',
  visibility text not null default 'authenticated',
  venue_name text,
  venue_area text not null,
  starts_at timestamptz not null,
  ends_at timestamptz,
  capacity_min integer,
  capacity_max integer not null,
  cancellation_reason text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint community_games_sport_slug_format check (
    sport_slug ~ '^[a-z0-9_]{2,40}$'
  ),
  constraint community_games_title_length check (
    length(btrim(title)) between 3 and 80
  ),
  constraint community_games_description_length check (
    description is null
    or length(description) <= 1000
  ),
  constraint community_games_lifecycle_state_check check (
    lifecycle_state in (
      'draft',
      'published',
      'filling',
      'confirmed',
      'in_progress',
      'completed',
      'cancelled'
    )
  ),
  constraint community_games_visibility_check check (
    visibility in (
      'private',
      'authenticated',
      'public'
    )
  ),
  constraint community_games_venue_name_length check (
    venue_name is null
    or length(btrim(venue_name)) between 2 and 120
  ),
  constraint community_games_venue_area_length check (
    length(btrim(venue_area)) between 2 and 160
  ),
  constraint community_games_ends_after_starts check (
    ends_at is null
    or ends_at > starts_at
  ),
  constraint community_games_capacity_min_check check (
    capacity_min is null
    or capacity_min between 1 and 64
  ),
  constraint community_games_capacity_max_check check (
    capacity_max between 2 and 64
  ),
  constraint community_games_capacity_order_check check (
    capacity_min is null
    or capacity_min <= capacity_max
  ),
  constraint community_games_cancellation_reason_length check (
    cancellation_reason is null
    or length(cancellation_reason) <= 500
  )
);

create index community_games_organizer_profile_id_idx
  on public.community_games (organizer_profile_id);

create index community_games_sport_slug_idx
  on public.community_games (sport_slug);

create index community_games_visible_starts_at_idx
  on public.community_games (starts_at)
  where visibility in ('authenticated', 'public')
    and lifecycle_state in ('published', 'filling', 'confirmed', 'in_progress');

create trigger community_games_set_updated_at
before update on public.community_games
for each row
execute function public.set_updated_at();

create table public.community_game_participants (
  id uuid primary key default gen_random_uuid(),
  community_game_id uuid not null references public.community_games (id) on delete cascade,
  profile_id uuid not null references public.profiles (id) on delete cascade,
  participant_state text not null default 'joined',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint community_game_participants_unique_profile unique (
    community_game_id,
    profile_id
  ),
  constraint community_game_participants_state_check check (
    participant_state in (
      'joined',
      'left',
      'removed',
      'waitlisted',
      'no_show'
    )
  )
);

create index community_game_participants_game_id_idx
  on public.community_game_participants (community_game_id);

create index community_game_participants_profile_id_idx
  on public.community_game_participants (profile_id);

create index community_game_participants_active_idx
  on public.community_game_participants (community_game_id, participant_state)
  where participant_state in ('joined', 'waitlisted');

create trigger community_game_participants_set_updated_at
before update on public.community_game_participants
for each row
execute function public.set_updated_at();

alter table public.community_games enable row level security;
alter table public.community_game_participants enable row level security;

create schema if not exists app_private;

revoke all on schema app_private from public;

create or replace function app_private.current_user_owns_profile(
  check_profile_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles
    where profiles.id = check_profile_id
      and profiles.user_id = (select auth.uid())
  );
$$;

create or replace function app_private.current_user_participates_in_community_game(
  check_community_game_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.community_game_participants
    where community_game_participants.community_game_id = check_community_game_id
      and community_game_participants.participant_state in (
        'joined',
        'waitlisted',
        'left',
        'no_show'
      )
      and app_private.current_user_owns_profile(community_game_participants.profile_id)
  );
$$;

revoke all on function app_private.current_user_owns_profile(uuid) from public;
revoke all on function app_private.current_user_participates_in_community_game(uuid) from public;
grant usage on schema app_private to authenticated;
grant execute on function app_private.current_user_owns_profile(uuid) to authenticated;
grant execute on function app_private.current_user_participates_in_community_game(uuid) to authenticated;

create policy "community_games_organizer_select"
on public.community_games
for select
to authenticated
using (app_private.current_user_owns_profile(community_games.organizer_profile_id));

create policy "community_games_visible_select"
on public.community_games
for select
to authenticated
using (
  visibility in ('authenticated', 'public')
  and lifecycle_state in (
    'published',
    'filling',
    'confirmed',
    'in_progress',
    'completed'
  )
);

create policy "community_games_participant_select"
on public.community_games
for select
to authenticated
using (app_private.current_user_participates_in_community_game(community_games.id));

create policy "community_games_organizer_insert"
on public.community_games
for insert
to authenticated
with check (app_private.current_user_owns_profile(community_games.organizer_profile_id));

create policy "community_games_organizer_update"
on public.community_games
for update
to authenticated
using (app_private.current_user_owns_profile(community_games.organizer_profile_id))
with check (app_private.current_user_owns_profile(community_games.organizer_profile_id));

create policy "community_game_participants_visible_select"
on public.community_game_participants
for select
to authenticated
using (
  participant_state in ('joined', 'waitlisted')
  and exists (
    select 1
    from public.community_games
    where community_games.id = community_game_participants.community_game_id
      and community_games.visibility in ('authenticated', 'public')
      and community_games.lifecycle_state in (
        'published',
        'filling',
        'confirmed',
        'in_progress',
        'completed'
      )
  )
);

create policy "community_game_participants_owner_select"
on public.community_game_participants
for select
to authenticated
using (app_private.current_user_owns_profile(community_game_participants.profile_id));

create policy "community_game_participants_organizer_select"
on public.community_game_participants
for select
to authenticated
using (
  exists (
    select 1
    from public.community_games
    where community_games.id = community_game_participants.community_game_id
      and app_private.current_user_owns_profile(community_games.organizer_profile_id)
  )
);

create policy "community_game_participants_join_insert"
on public.community_game_participants
for insert
to authenticated
with check (
  participant_state in ('joined', 'waitlisted')
  and app_private.current_user_owns_profile(community_game_participants.profile_id)
  and exists (
    select 1
    from public.community_games
    where community_games.id = community_game_participants.community_game_id
      and community_games.visibility in ('authenticated', 'public')
      and community_games.lifecycle_state in (
        'published',
        'filling',
        'confirmed'
      )
  )
);

create policy "community_game_participants_owner_leave_update"
on public.community_game_participants
for update
to authenticated
using (app_private.current_user_owns_profile(community_game_participants.profile_id))
with check (
  participant_state = 'left'
  and app_private.current_user_owns_profile(community_game_participants.profile_id)
);

create policy "community_game_participants_organizer_update"
on public.community_game_participants
for update
to authenticated
using (
  exists (
    select 1
    from public.community_games
    where community_games.id = community_game_participants.community_game_id
      and app_private.current_user_owns_profile(community_games.organizer_profile_id)
  )
)
with check (
  participant_state in ('joined', 'waitlisted', 'removed', 'no_show')
  and exists (
    select 1
    from public.community_games
    where community_games.id = community_game_participants.community_game_id
      and app_private.current_user_owns_profile(community_games.organizer_profile_id)
  )
);

revoke all on public.community_games from anon, authenticated;
revoke all on public.community_game_participants from anon, authenticated;

grant select on public.community_games to authenticated;

grant insert (
  organizer_profile_id,
  sport_slug,
  title,
  description,
  lifecycle_state,
  visibility,
  venue_name,
  venue_area,
  starts_at,
  ends_at,
  capacity_min,
  capacity_max
) on public.community_games to authenticated;

grant update (
  sport_slug,
  title,
  description,
  lifecycle_state,
  visibility,
  venue_name,
  venue_area,
  starts_at,
  ends_at,
  capacity_min,
  capacity_max,
  cancellation_reason
) on public.community_games to authenticated;

grant select on public.community_game_participants to authenticated;

grant insert (
  community_game_id,
  profile_id,
  participant_state
) on public.community_game_participants to authenticated;

grant update (
  participant_state
) on public.community_game_participants to authenticated;
