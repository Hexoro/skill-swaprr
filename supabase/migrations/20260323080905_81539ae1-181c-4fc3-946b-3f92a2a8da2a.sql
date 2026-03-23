
-- Fix: Add badges column to profiles first, then create views and missing tables
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS badges jsonb DEFAULT '[]';
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS display_theme text DEFAULT '';

-- Events columns
ALTER TABLE public.events
  ADD COLUMN IF NOT EXISTS spots_filled integer DEFAULT 0,
  ADD COLUMN IF NOT EXISTS event_date timestamptz,
  ADD COLUMN IF NOT EXISTS location text DEFAULT '',
  ADD COLUMN IF NOT EXISTS image_url text DEFAULT '',
  ADD COLUMN IF NOT EXISTS max_spots integer DEFAULT 0,
  ADD COLUMN IF NOT EXISTS category text DEFAULT 'General',
  ADD COLUMN IF NOT EXISTS status text DEFAULT 'upcoming',
  ADD COLUMN IF NOT EXISTS organizer_id uuid,
  ADD COLUMN IF NOT EXISTS organizer_name text DEFAULT '';

ALTER TABLE public.event_registrations ADD COLUMN IF NOT EXISTS status text DEFAULT 'registered';
ALTER TABLE public.bug_bounty_submissions ADD COLUMN IF NOT EXISTS reward integer DEFAULT 0, ADD COLUMN IF NOT EXISTS submitted_by uuid;
ALTER TABLE public.listings ADD COLUMN IF NOT EXISTS price integer DEFAULT 0, ADD COLUMN IF NOT EXISTS points integer DEFAULT 0, ADD COLUMN IF NOT EXISTS views integer DEFAULT 0;
ALTER TABLE public.page_sessions ADD COLUMN IF NOT EXISTS duration_seconds integer DEFAULT 0;
ALTER TABLE public.guilds ADD COLUMN IF NOT EXISTS guild_sections jsonb DEFAULT '[]';
ALTER TABLE public.jury_assignments ADD COLUMN IF NOT EXISTS status text DEFAULT 'assigned';

-- Views
CREATE OR REPLACE VIEW public.public_profiles AS
SELECT user_id, full_name, display_name, avatar_url, avatar_emoji, bio, slogan, university, location, skills, skill_levels, interests, needs, elo, tier, sp, total_gigs_completed, portfolio_items, badges, certificates, availability, response_time, hourly_rate, streak_days, created_at FROM public.profiles;

CREATE OR REPLACE VIEW public.leaderboard_achievements AS
SELECT ua.user_id, ua.achievement_id, a.name AS achievement_name, a.description AS achievement_description, a.icon AS achievement_icon, ua.completed, ua.completed_at FROM public.user_achievements ua JOIN public.achievements a ON a.id = ua.achievement_id;

-- Missing tables
CREATE TABLE IF NOT EXISTS public.help_articles (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), title text NOT NULL, content text NOT NULL DEFAULT '', category text DEFAULT 'General', slug text, created_at timestamptz DEFAULT now());
ALTER TABLE public.help_articles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Help articles viewable by everyone" ON public.help_articles FOR SELECT USING (true);

CREATE TABLE IF NOT EXISTS public.service_status (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), service_name text NOT NULL, status text DEFAULT 'operational', uptime numeric DEFAULT 100, created_at timestamptz DEFAULT now());
ALTER TABLE public.service_status ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service status viewable by everyone" ON public.service_status FOR SELECT USING (true);

CREATE TABLE IF NOT EXISTS public.service_incidents (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), service_id uuid REFERENCES public.service_status(id) ON DELETE CASCADE, title text NOT NULL, description text DEFAULT '', severity text DEFAULT 'low', status text DEFAULT 'resolved', created_at timestamptz DEFAULT now());
ALTER TABLE public.service_incidents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service incidents viewable by everyone" ON public.service_incidents FOR SELECT USING (true);

CREATE TABLE IF NOT EXISTS public.enterprise_candidates (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), account_id uuid REFERENCES public.enterprise_accounts(id) ON DELETE CASCADE, user_id uuid, name text NOT NULL DEFAULT '', skills text[] DEFAULT '{}', status text DEFAULT 'active', created_at timestamptz DEFAULT now());
ALTER TABLE public.enterprise_candidates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enterprise admins can view candidates" ON public.enterprise_candidates FOR SELECT USING (public.has_role(auth.uid(), 'admin'));
