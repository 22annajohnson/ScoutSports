-- Jira: SOCIAL-88
-- Tech Plan: implementation/proposed/PROFILE-006-profile-database-schema.md
-- Purpose: Create the V1 profile schema foundation for player identity.
-- Affected Area: Supabase
-- RLS Impact: Enables RLS on profile tables; policies are added in SOCIAL-89.
-- Generated Types: Deferred; SOCIAL-90 owns generated type refresh.
-- Rollback: Forward-fix with a follow-up migration unless review identifies a safe local-only reset.

create extension if not exists pgcrypto with schema extensions;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create table public.profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  display_name text,
  username text,
  profile_photo_path text,
  action_photo_path text,
  bio text,
  profile_completion_state text not null default 'account_created',
  account_status text not null default 'active',
  last_active_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint profiles_user_id_key unique (user_id),
  constraint profiles_display_name_length check (
    display_name is null
    or length(btrim(display_name)) between 2 and 40
  ),
  constraint profiles_username_format check (
    username is null
    or username ~ '^[a-z0-9_]{3,24}$'
  ),
  constraint profiles_bio_length check (
    bio is null
    or length(bio) <= 500
  ),
  constraint profiles_completion_state_check check (
    profile_completion_state in (
      'account_created',
      'basic_identity',
      'discovery_ready',
      'event_ready',
      'fully_complete'
    )
  ),
  constraint profiles_account_status_check check (
    account_status in (
      'active',
      'restricted',
      'disabled',
      'deleted'
    )
  )
);

create unique index profiles_username_unique_idx
  on public.profiles (username)
  where username is not null;

create index profiles_user_id_idx
  on public.profiles (user_id);

create index profiles_account_status_idx
  on public.profiles (account_status);

create trigger profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

create table public.profile_sports (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles (id) on delete cascade,
  sport_slug text not null,
  skill_level text,
  is_primary boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint profile_sports_profile_sport_key unique (profile_id, sport_slug),
  constraint profile_sports_sport_slug_format check (
    sport_slug ~ '^[a-z0-9_]{2,40}$'
  ),
  constraint profile_sports_skill_level_length check (
    skill_level is null
    or length(btrim(skill_level)) between 2 and 40
  )
);

create unique index profile_sports_one_primary_idx
  on public.profile_sports (profile_id)
  where is_primary;

create index profile_sports_sport_slug_idx
  on public.profile_sports (sport_slug);

create trigger profile_sports_set_updated_at
before update on public.profile_sports
for each row
execute function public.set_updated_at();

create table public.profile_availability (
  profile_id uuid primary key references public.profiles (id) on delete cascade,
  preferred_days text[] not null default '{}',
  preferred_times text[] not null default '{}',
  play_intent text,
  home_area text,
  travel_radius_miles integer,
  preferred_play_style text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint profile_availability_preferred_days_check check (
    preferred_days <@ array[
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ]::text[]
  ),
  constraint profile_availability_preferred_times_check check (
    preferred_times <@ array[
      'morning',
      'afternoon',
      'evening',
      'flexible'
    ]::text[]
  ),
  constraint profile_availability_play_intent_length check (
    play_intent is null
    or length(btrim(play_intent)) between 2 and 40
  ),
  constraint profile_availability_home_area_length check (
    home_area is null
    or length(btrim(home_area)) between 2 and 120
  ),
  constraint profile_availability_travel_radius_check check (
    travel_radius_miles is null
    or travel_radius_miles between 1 and 100
  ),
  constraint profile_availability_play_style_length check (
    preferred_play_style is null
    or length(btrim(preferred_play_style)) between 2 and 40
  )
);

create trigger profile_availability_set_updated_at
before update on public.profile_availability
for each row
execute function public.set_updated_at();

create table public.profile_privacy (
  profile_id uuid primary key references public.profiles (id) on delete cascade,
  profile_visibility text not null default 'private',
  discoverable boolean not null default false,
  location_precision text not null default 'coarse',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint profile_privacy_visibility_check check (
    profile_visibility in (
      'private',
      'authenticated',
      'public'
    )
  ),
  constraint profile_privacy_location_precision_check check (
    location_precision in (
      'hidden',
      'coarse'
    )
  )
);

create index profile_privacy_discoverable_idx
  on public.profile_privacy (discoverable)
  where discoverable;

create trigger profile_privacy_set_updated_at
before update on public.profile_privacy
for each row
execute function public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.profile_sports enable row level security;
alter table public.profile_availability enable row level security;
alter table public.profile_privacy enable row level security;
