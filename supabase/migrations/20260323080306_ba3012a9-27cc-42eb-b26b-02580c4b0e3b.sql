
-- ═══════════════════════════════════════════════════════
-- Migration 1: Enum updates, profiles expansion, activity_log, handle_new_user fix
-- ═══════════════════════════════════════════════════════

-- Add missing enum values
ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'moderator';
ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'enterprise';

-- Drop existing trigger on profiles that might conflict
DROP TRIGGER IF EXISTS update_profiles_updated_at ON public.profiles;

-- Drop existing policies that will be recreated
DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;

-- Expand profiles table with all missing columns
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS full_name TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS email TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS avatar_url TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS avatar_emoji TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS bio TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS slogan TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS university TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS location TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS timezone TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS languages TEXT[] DEFAULT ARRAY['English']::TEXT[],
  ADD COLUMN IF NOT EXISTS portfolio_url TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS linkedin_url TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS github_url TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS twitter_url TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS instagram_url TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS youtube_url TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS personal_website TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS skills TEXT[] DEFAULT '{}'::TEXT[],
  ADD COLUMN IF NOT EXISTS skill_levels JSONB DEFAULT '{}'::JSONB,
  ADD COLUMN IF NOT EXISTS interests TEXT[] DEFAULT '{}'::TEXT[],
  ADD COLUMN IF NOT EXISTS needs TEXT[] DEFAULT '{}'::TEXT[],
  ADD COLUMN IF NOT EXISTS work_history JSONB DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS education_history JSONB DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS certificates JSONB DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS portfolio_items JSONB DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS availability TEXT DEFAULT 'Part-time',
  ADD COLUMN IF NOT EXISTS response_time TEXT DEFAULT 'Within 24 hours',
  ADD COLUMN IF NOT EXISTS preferred_comm TEXT DEFAULT 'Chat',
  ADD COLUMN IF NOT EXISTS hourly_rate TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS referral_code TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS referred_by TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS id_verified BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS onboarding_complete BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS sp INT NOT NULL DEFAULT 100,
  ADD COLUMN IF NOT EXISTS elo INT NOT NULL DEFAULT 1000,
  ADD COLUMN IF NOT EXISTS tier TEXT NOT NULL DEFAULT 'Bronze',
  ADD COLUMN IF NOT EXISTS total_gigs_completed INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS streak_days INT DEFAULT 0;

-- Make user_id unique if not already
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'profiles_user_id_key') THEN
    ALTER TABLE public.profiles ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);
  END IF;
END $$;

-- Add delete policy for profiles
CREATE POLICY "Users can delete their own profile"
  ON public.profiles FOR DELETE USING (auth.uid() = user_id);

-- Recreate profiles policies
CREATE POLICY "Profiles are viewable by everyone"
  ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own profile"
  ON public.profiles FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Recreate trigger
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Activity log table
CREATE TABLE IF NOT EXISTS public.activity_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  action TEXT NOT NULL,
  entity_type TEXT,
  entity_id UUID,
  metadata JSONB DEFAULT '{}'::JSONB,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.activity_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own activity"
  ON public.activity_log FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own activity"
  ON public.activity_log FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all activity"
  ON public.activity_log FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

-- Indexes
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_log_user_id ON public.activity_log(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_log_action ON public.activity_log(action);
CREATE INDEX IF NOT EXISTS idx_activity_log_created_at ON public.activity_log(created_at DESC);

-- Update handle_new_user function
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (user_id, full_name, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.email, '')
  );
  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
