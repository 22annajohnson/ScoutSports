-- Jira: SOCIAL-117
-- Tech Plan: implementation/proposed/EVENT-002-community-games-v1.md
-- Purpose: Validate Community Games V1 schema and RLS boundaries.
-- Affected Area: Supabase
-- RLS Impact: Tests organizer, participant, and visible-event access.

begin;

select plan(12);

select has_table('public', 'community_games', 'community_games table exists');
select has_table('public', 'community_game_participants', 'community_game_participants table exists');

create temporary table social_117_ids (
  owner_user_id uuid not null,
  participant_user_id uuid not null,
  unrelated_user_id uuid not null,
  owner_profile_id uuid not null,
  participant_profile_id uuid not null,
  unrelated_profile_id uuid not null,
  private_game_id uuid not null,
  visible_game_id uuid not null
) on commit drop;

insert into social_117_ids
select
  gen_random_uuid(),
  gen_random_uuid(),
  gen_random_uuid(),
  gen_random_uuid(),
  gen_random_uuid(),
  gen_random_uuid(),
  gen_random_uuid(),
  gen_random_uuid();

grant select on social_117_ids to authenticated;

insert into auth.users (
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at
)
select
  owner_user_id,
  'authenticated',
  'authenticated',
  'event-owner@example.com',
  '',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
from social_117_ids
union all
select
  participant_user_id,
  'authenticated',
  'authenticated',
  'event-participant@example.com',
  '',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
from social_117_ids
union all
select
  unrelated_user_id,
  'authenticated',
  'authenticated',
  'event-unrelated@example.com',
  '',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
from social_117_ids;

insert into public.profiles (
  id,
  user_id,
  display_name,
  profile_completion_state,
  account_status
)
select
  owner_profile_id,
  owner_user_id,
  'Event Owner',
  'event_ready',
  'active'
from social_117_ids
union all
select
  participant_profile_id,
  participant_user_id,
  'Event Participant',
  'event_ready',
  'active'
from social_117_ids
union all
select
  unrelated_profile_id,
  unrelated_user_id,
  'Event Unrelated',
  'event_ready',
  'active'
from social_117_ids;

insert into public.profile_privacy (
  profile_id,
  profile_visibility,
  discoverable,
  location_precision
)
select owner_profile_id, 'authenticated', true, 'coarse'
from social_117_ids
union all
select participant_profile_id, 'authenticated', true, 'coarse'
from social_117_ids
union all
select unrelated_profile_id, 'authenticated', true, 'coarse'
from social_117_ids;

insert into public.community_games (
  id,
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
)
select
  private_game_id,
  owner_profile_id,
  'pickleball',
  'Private Drill Session',
  'Invite-only coordination fixture.',
  'published',
  'private',
  'Scout Court',
  'Downtown',
  timezone('utc', now()) + interval '1 day',
  timezone('utc', now()) + interval '1 day 2 hours',
  2,
  4
from social_117_ids
union all
select
  visible_game_id,
  owner_profile_id,
  'pickleball',
  'Open Community Game',
  'Visible coordination fixture.',
  'published',
  'authenticated',
  'Scout Court',
  'Downtown',
  timezone('utc', now()) + interval '2 days',
  timezone('utc', now()) + interval '2 days 2 hours',
  2,
  4
from social_117_ids;

insert into public.community_game_participants (
  community_game_id,
  profile_id,
  participant_state
)
select private_game_id, participant_profile_id, 'joined'
from social_117_ids;

set local role authenticated;
select set_config('request.jwt.claim.sub', owner_user_id::text, true)
from social_117_ids;

select is(
  (select count(*)::integer from public.community_games where id = (select private_game_id from social_117_ids)),
  1,
  'organizer can read a private event they own'
);

select lives_ok(
  format(
    $$
      insert into public.community_games (
        organizer_profile_id,
        sport_slug,
        title,
        lifecycle_state,
        visibility,
        venue_area,
        starts_at,
        capacity_max
      )
      values (
        %L::uuid,
        'pickleball',
        'Owner Created Game',
        'draft',
        'private',
        'Downtown',
        timezone('utc', now()) + interval '3 days',
        4
      )
    $$,
    (select owner_profile_id from social_117_ids)
  ),
  'organizer can create an event for their own profile'
);

reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', unrelated_user_id::text, true)
from social_117_ids;

select is(
  (select count(*)::integer from public.community_games where id = (select private_game_id from social_117_ids)),
  0,
  'unrelated user cannot read a private event'
);

select is(
  (select count(*)::integer from public.community_games where id = (select visible_game_id from social_117_ids)),
  1,
  'authenticated user can read a visible published event'
);

select throws_ok(
  format(
    $$
      insert into public.community_games (
        organizer_profile_id,
        sport_slug,
        title,
        lifecycle_state,
        visibility,
        venue_area,
        starts_at,
        capacity_max
      )
      values (
        %L::uuid,
        'pickleball',
        'Invalid Organizer Game',
        'draft',
        'private',
        'Downtown',
        timezone('utc', now()) + interval '3 days',
        4
      )
    $$,
    (select owner_profile_id from social_117_ids)
  ),
  '42501',
  null,
  'non-owner cannot create an event for another organizer profile'
);

reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', participant_user_id::text, true)
from social_117_ids;

select is(
  (select count(*)::integer from public.community_games where id = (select private_game_id from social_117_ids)),
  1,
  'participant can read a private event they joined'
);

select is(
  (select count(*)::integer from public.community_game_participants where community_game_id = (select private_game_id from social_117_ids)),
  1,
  'participant can read their own private participation row'
);

select lives_ok(
  format(
    $$
      insert into public.community_game_participants (
        community_game_id,
        profile_id,
        participant_state
      )
      values (
        %L::uuid,
        %L::uuid,
        'joined'
      )
    $$,
    (select visible_game_id from social_117_ids),
    (select participant_profile_id from social_117_ids)
  ),
  'authenticated player can join a visible active event'
);

select lives_ok(
  format(
    $$
      update public.community_game_participants
      set participant_state = 'left'
      where community_game_id = %L::uuid
        and profile_id = %L::uuid
    $$,
    (select visible_game_id from social_117_ids),
    (select participant_profile_id from social_117_ids)
  ),
  'participant can leave their own event participation'
);

select throws_ok(
  format(
    $$
      update public.community_game_participants
      set participant_state = 'removed'
      where community_game_id = %L::uuid
        and profile_id = %L::uuid
    $$,
    (select private_game_id from social_117_ids),
    (select participant_profile_id from social_117_ids)
  ),
  '42501',
  null,
  'participant cannot mark themselves removed'
);

reset role;

select * from finish();

rollback;
