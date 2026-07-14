-- Jira: SOCIAL-89
-- Tech Plan: implementation/approved/PROFILE-006-profile-database-schema.md
-- Purpose: Add RLS policies for V1 profile schema tables.
-- Affected Area: Supabase
-- RLS Impact: Adds owner access, safe visible contract views, and default denial for private profile data.
-- Generated Types: Deferred; SOCIAL-90 owns generated type refresh.
-- Rollback: Forward-fix with a follow-up migration unless review identifies a safe local-only reset.

create policy "profiles_owner_select"
on public.profiles
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "profiles_visible_select"
on public.profiles
for select
to authenticated
using (
  account_status = 'active'
  and exists (
    select 1
    from public.profile_privacy
    where profile_privacy.profile_id = profiles.id
      and profile_privacy.profile_visibility in ('authenticated', 'public')
  )
);

create policy "profiles_owner_insert"
on public.profiles
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "profiles_owner_update"
on public.profiles
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "profile_sports_owner_select"
on public.profile_sports
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_sports.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_sports_visible_select"
on public.profile_sports
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles
    join public.profile_privacy
      on profile_privacy.profile_id = profiles.id
    where profiles.id = profile_sports.profile_id
      and profiles.account_status = 'active'
      and profile_privacy.profile_visibility in ('authenticated', 'public')
  )
);

create policy "profile_sports_owner_insert"
on public.profile_sports
for insert
to authenticated
with check (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_sports.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_sports_owner_update"
on public.profile_sports
for update
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_sports.profile_id
      and profiles.user_id = (select auth.uid())
  )
)
with check (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_sports.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_sports_owner_delete"
on public.profile_sports
for delete
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_sports.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_availability_owner_select"
on public.profile_availability
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_availability.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_availability_owner_insert"
on public.profile_availability
for insert
to authenticated
with check (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_availability.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_availability_owner_update"
on public.profile_availability
for update
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_availability.profile_id
      and profiles.user_id = (select auth.uid())
  )
)
with check (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_availability.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_availability_owner_delete"
on public.profile_availability
for delete
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_availability.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_privacy_owner_select"
on public.profile_privacy
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_privacy.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_privacy_visible_select"
on public.profile_privacy
for select
to authenticated
using (profile_visibility in ('authenticated', 'public'));

create policy "profile_privacy_owner_insert"
on public.profile_privacy
for insert
to authenticated
with check (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_privacy.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create policy "profile_privacy_owner_update"
on public.profile_privacy
for update
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_privacy.profile_id
      and profiles.user_id = (select auth.uid())
  )
)
with check (
  exists (
    select 1
    from public.profiles
    where profiles.id = profile_privacy.profile_id
      and profiles.user_id = (select auth.uid())
  )
);

create view public.profile_public_summaries
with (security_invoker = true)
as
select
  profiles.id as profile_id,
  profiles.display_name,
  profiles.username,
  profiles.profile_photo_path,
  profiles.bio,
  profiles.profile_completion_state,
  profile_privacy.profile_visibility,
  profile_privacy.discoverable,
  profile_privacy.location_precision
from public.profiles
join public.profile_privacy
  on profile_privacy.profile_id = profiles.id
where profile_privacy.profile_visibility in ('authenticated', 'public');

create view public.profile_sport_summaries
with (security_invoker = true)
as
select
  profile_sports.profile_id,
  profile_sports.sport_slug,
  profile_sports.skill_level,
  profile_sports.is_primary
from public.profile_sports
join public.profile_privacy
  on profile_privacy.profile_id = profile_sports.profile_id
where profile_privacy.profile_visibility in ('authenticated', 'public');

grant select on public.profile_public_summaries to authenticated;
grant select on public.profile_sport_summaries to authenticated;

revoke all on public.profiles from anon, authenticated;
revoke all on public.profile_sports from anon, authenticated;
revoke all on public.profile_availability from anon, authenticated;
revoke all on public.profile_privacy from anon, authenticated;

grant select (
  id,
  display_name,
  username,
  profile_photo_path,
  action_photo_path,
  bio,
  profile_completion_state
) on public.profiles to authenticated;

grant insert (
  user_id,
  display_name,
  username,
  profile_photo_path,
  action_photo_path,
  bio
) on public.profiles to authenticated;

grant update (
  display_name,
  username,
  profile_photo_path,
  action_photo_path,
  bio
) on public.profiles to authenticated;

grant select (
  profile_id,
  sport_slug,
  skill_level,
  is_primary
) on public.profile_sports to authenticated;

grant insert (
  profile_id,
  sport_slug,
  skill_level,
  is_primary
) on public.profile_sports to authenticated;

grant update (
  sport_slug,
  skill_level,
  is_primary
) on public.profile_sports to authenticated;

grant delete on public.profile_sports to authenticated;

grant select on public.profile_availability to authenticated;

grant insert (
  profile_id,
  preferred_days,
  preferred_times,
  play_intent,
  home_area,
  travel_radius_miles,
  preferred_play_style
) on public.profile_availability to authenticated;

grant update (
  preferred_days,
  preferred_times,
  play_intent,
  home_area,
  travel_radius_miles,
  preferred_play_style
) on public.profile_availability to authenticated;

grant delete on public.profile_availability to authenticated;

grant select (
  profile_id,
  profile_visibility,
  discoverable,
  location_precision
) on public.profile_privacy to authenticated;

grant insert (
  profile_id,
  profile_visibility,
  discoverable,
  location_precision
) on public.profile_privacy to authenticated;

grant update (
  profile_visibility,
  discoverable,
  location_precision
) on public.profile_privacy to authenticated;
