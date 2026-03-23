
-- ═══════════════════════════════════════════════════════
-- Migration 4: Guilds, Badges, Achievements, Notifications
-- ═══════════════════════════════════════════════════════

-- Guilds
CREATE TABLE IF NOT EXISTS public.guilds (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  logo_url text DEFAULT '',
  banner_url text DEFAULT '',
  category text DEFAULT 'General',
  is_public boolean DEFAULT true,
  member_count integer DEFAULT 0,
  max_members integer DEFAULT 50,
  level integer DEFAULT 1,
  xp integer DEFAULT 0,
  treasury_sp integer DEFAULT 0,
  created_by uuid NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE public.guilds ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guilds viewable by everyone" ON public.guilds FOR SELECT USING (true);

-- Guild members
CREATE TABLE IF NOT EXISTS public.guild_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guild_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE NOT NULL,
  user_id uuid NOT NULL,
  role text DEFAULT 'Member',
  joined_at timestamptz DEFAULT now()
);
ALTER TABLE public.guild_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guild members viewable by everyone" ON public.guild_members FOR SELECT USING (true);
CREATE POLICY "Users can join guilds" ON public.guild_members FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can leave guilds" ON public.guild_members FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Guild leaders can manage members" ON public.guild_members FOR UPDATE USING (
  EXISTS (SELECT 1 FROM public.guild_members gm WHERE gm.guild_id = guild_members.guild_id AND gm.user_id = auth.uid() AND gm.role IN ('Guild Master', 'Officer'))
);

-- Guild projects
CREATE TABLE IF NOT EXISTS public.guild_projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guild_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  description text DEFAULT '',
  status text DEFAULT 'active',
  sp_budget integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.guild_projects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guild projects viewable by everyone" ON public.guild_projects FOR SELECT USING (true);

-- Guild treasury log
CREATE TABLE IF NOT EXISTS public.guild_treasury_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guild_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE NOT NULL,
  amount integer NOT NULL,
  type text NOT NULL,
  description text DEFAULT '',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.guild_treasury_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guild treasury viewable by members" ON public.guild_treasury_log FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.guild_members gm WHERE gm.guild_id = guild_treasury_log.guild_id AND gm.user_id = auth.uid())
);

-- Guild loans
CREATE TABLE IF NOT EXISTS public.guild_loans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guild_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE NOT NULL,
  borrower_id uuid NOT NULL,
  amount integer NOT NULL,
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.guild_loans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guild loans viewable by members" ON public.guild_loans FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.guild_members gm WHERE gm.guild_id = guild_loans.guild_id AND gm.user_id = auth.uid())
);

-- Guild wars
CREATE TABLE IF NOT EXISTS public.guild_wars (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  challenger_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE,
  defender_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE,
  status text DEFAULT 'pending',
  winner_id uuid,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.guild_wars ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guild wars viewable by everyone" ON public.guild_wars FOR SELECT USING (true);

-- Badges
CREATE TABLE IF NOT EXISTS public.badges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  icon text DEFAULT '',
  rarity text DEFAULT 'common',
  category text DEFAULT 'general',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Badges viewable by everyone" ON public.badges FOR SELECT USING (true);

-- User badges
CREATE TABLE IF NOT EXISTS public.user_badges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  badge_id uuid REFERENCES public.badges(id) ON DELETE CASCADE NOT NULL,
  earned_at timestamptz DEFAULT now(),
  UNIQUE(user_id, badge_id)
);
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "User badges viewable by everyone" ON public.user_badges FOR SELECT USING (true);

-- Guild badges
CREATE TABLE IF NOT EXISTS public.guild_badges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guild_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE NOT NULL,
  badge_id uuid REFERENCES public.badges(id) ON DELETE CASCADE NOT NULL,
  earned_at timestamptz DEFAULT now(),
  UNIQUE(guild_id, badge_id)
);
ALTER TABLE public.guild_badges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guild badges viewable by everyone" ON public.guild_badges FOR SELECT USING (true);

-- Achievements
CREATE TABLE IF NOT EXISTS public.achievements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  icon text DEFAULT '',
  category text DEFAULT 'general',
  threshold integer DEFAULT 1,
  sp_reward integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Achievements viewable by everyone" ON public.achievements FOR SELECT USING (true);

-- User achievements
CREATE TABLE IF NOT EXISTS public.user_achievements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  achievement_id uuid REFERENCES public.achievements(id) ON DELETE CASCADE NOT NULL,
  progress integer DEFAULT 0,
  completed boolean DEFAULT false,
  completed_at timestamptz,
  UNIQUE(user_id, achievement_id)
);
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "User achievements viewable by everyone" ON public.user_achievements FOR SELECT USING (true);

-- Guild achievements
CREATE TABLE IF NOT EXISTS public.guild_achievements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guild_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE NOT NULL,
  achievement_id uuid REFERENCES public.achievements(id) ON DELETE CASCADE NOT NULL,
  progress integer DEFAULT 0,
  completed boolean DEFAULT false,
  completed_at timestamptz,
  UNIQUE(guild_id, achievement_id)
);
ALTER TABLE public.guild_achievements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guild achievements viewable by everyone" ON public.guild_achievements FOR SELECT USING (true);

-- Guild management policies
CREATE POLICY "Guild leaders can update guild" ON public.guilds FOR UPDATE
USING (
  EXISTS (SELECT 1 FROM public.guild_members WHERE guild_members.guild_id = guilds.id AND guild_members.user_id = auth.uid() AND guild_members.role IN ('Guild Master', 'Officer'))
);
CREATE POLICY "Authenticated users can create guilds" ON public.guilds FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Notifications
CREATE TABLE IF NOT EXISTS public.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  type text NOT NULL DEFAULT 'info',
  title text NOT NULL,
  message text DEFAULT '',
  link text DEFAULT '',
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "System can insert notifications" ON public.notifications FOR INSERT TO authenticated WITH CHECK (auth.uid() IS NOT NULL);

-- Ranking history
CREATE TABLE IF NOT EXISTS public.ranking_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  elo integer NOT NULL,
  tier text NOT NULL,
  reason text DEFAULT '',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.ranking_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own ranking history" ON public.ranking_history FOR SELECT USING (auth.uid() = user_id);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_guild_members_guild ON public.guild_members(guild_id);
CREATE INDEX IF NOT EXISTS idx_guild_members_user ON public.guild_members(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON public.notifications(user_id, is_read);

-- Enable realtime for notifications
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

-- FK from guild_members to profiles
ALTER TABLE public.guild_members
  ADD CONSTRAINT guild_members_user_id_profiles_fkey
  FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;

ALTER TABLE public.user_badges
  ADD CONSTRAINT user_badges_user_id_profiles_fkey
  FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;

ALTER TABLE public.user_achievements
  ADD CONSTRAINT user_achievements_user_id_profiles_fkey
  FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;

ALTER TABLE public.listings
  ADD CONSTRAINT listings_user_id_profiles_fkey
  FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;

ALTER TABLE public.disputes
  ADD CONSTRAINT disputes_filed_by_profiles_fkey
  FOREIGN KEY (filed_by) REFERENCES public.profiles(user_id) ON DELETE CASCADE;

ALTER TABLE public.disputes
  ADD CONSTRAINT disputes_filed_against_profiles_fkey
  FOREIGN KEY (filed_against) REFERENCES public.profiles(user_id) ON DELETE CASCADE;
