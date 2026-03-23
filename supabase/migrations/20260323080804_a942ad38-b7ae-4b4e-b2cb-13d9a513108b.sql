
-- ═══════════════════════════════════════════════════════
-- Migration 6: Messaging, Enterprise, Support, Misc tables
-- ═══════════════════════════════════════════════════════

-- Conversations (DMs)
CREATE TABLE IF NOT EXISTS public.conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  participant_one uuid NOT NULL,
  participant_two uuid NOT NULL,
  last_message_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(participant_one, participant_two)
);
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Participants can view conversations" ON public.conversations FOR SELECT USING (auth.uid() = participant_one OR auth.uid() = participant_two);
CREATE POLICY "Authenticated can create conversations" ON public.conversations FOR INSERT WITH CHECK (auth.uid() = participant_one);
CREATE POLICY "Participants can update conversations" ON public.conversations FOR UPDATE USING (auth.uid() = participant_one OR auth.uid() = participant_two);

-- Direct messages
CREATE TABLE IF NOT EXISTS public.direct_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid REFERENCES public.conversations(id) ON DELETE CASCADE NOT NULL,
  sender_id uuid NOT NULL,
  content text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.direct_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Conversation members can view messages" ON public.direct_messages FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.conversations c WHERE c.id = conversation_id AND (c.participant_one = auth.uid() OR c.participant_two = auth.uid()))
);
CREATE POLICY "Members can send messages" ON public.direct_messages FOR INSERT WITH CHECK (auth.uid() = sender_id);
CREATE POLICY "Users can update own messages" ON public.direct_messages FOR UPDATE USING (auth.uid() = sender_id);

-- Guild channels
CREATE TABLE IF NOT EXISTS public.guild_channels (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guild_id uuid REFERENCES public.guilds(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL DEFAULT 'general',
  description text DEFAULT '',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.guild_channels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Guild channels viewable by everyone" ON public.guild_channels FOR SELECT USING (true);

-- Guild channel messages
CREATE TABLE IF NOT EXISTS public.guild_channel_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  channel_id uuid REFERENCES public.guild_channels(id) ON DELETE CASCADE NOT NULL,
  sender_id uuid NOT NULL,
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.guild_channel_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view guild messages" ON public.guild_channel_messages FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.guild_channels gc JOIN public.guild_members gm ON gm.guild_id = gc.guild_id WHERE gc.id = channel_id AND gm.user_id = auth.uid())
  OR EXISTS (SELECT 1 FROM public.guild_channels gc JOIN public.guilds g ON g.id = gc.guild_id WHERE gc.id = channel_id AND g.is_public = true)
);
CREATE POLICY "Members can send guild messages" ON public.guild_channel_messages FOR INSERT WITH CHECK (
  auth.uid() = sender_id AND
  EXISTS (SELECT 1 FROM public.guild_channels gc JOIN public.guild_members gm ON gm.guild_id = gc.guild_id WHERE gc.id = channel_id AND gm.user_id = auth.uid())
);

-- Support conversations
CREATE TABLE IF NOT EXISTS public.support_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid,
  status text DEFAULT 'open',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.support_conversations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own support" ON public.support_conversations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Anyone can create support" ON public.support_conversations FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- Support messages
CREATE TABLE IF NOT EXISTS public.support_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid REFERENCES public.support_conversations(id) ON DELETE CASCADE NOT NULL,
  sender text DEFAULT 'user',
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.support_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own support messages" ON public.support_messages FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.support_conversations sc WHERE sc.id = conversation_id AND sc.user_id = auth.uid())
);
CREATE POLICY "Users can send support messages" ON public.support_messages FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM public.support_conversations sc WHERE sc.id = conversation_id AND sc.user_id = auth.uid())
);

-- Enterprise tables
CREATE TABLE IF NOT EXISTS public.enterprise_projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  status text DEFAULT 'active',
  budget_sp integer DEFAULT 0,
  created_by uuid,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.enterprise_projects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enterprise projects viewable by admins" ON public.enterprise_projects FOR SELECT USING (public.has_role(auth.uid(), 'admin') OR created_by = auth.uid());

CREATE TABLE IF NOT EXISTS public.enterprise_consultations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  enterprise_id uuid,
  title text NOT NULL DEFAULT '',
  description text DEFAULT '',
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.enterprise_consultations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enterprise consultations viewable" ON public.enterprise_consultations FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

-- Saved posts
CREATE TABLE IF NOT EXISTS public.saved_posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  post_id uuid NOT NULL,
  post_type text NOT NULL CHECK (post_type IN ('blog', 'forum')),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, post_id, post_type)
);
ALTER TABLE public.saved_posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own saved posts" ON public.saved_posts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can save posts" ON public.saved_posts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can unsave posts" ON public.saved_posts FOR DELETE USING (auth.uid() = user_id);

-- Newsletter
CREATE TABLE IF NOT EXISTS public.newsletter_subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.newsletter_subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can subscribe" ON public.newsletter_subscriptions FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view subscriptions" ON public.newsletter_subscriptions FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

-- Contact submissions
CREATE TABLE IF NOT EXISTS public.contact_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid, name text NOT NULL, email text NOT NULL,
  phone text, topic text NOT NULL DEFAULT 'General Inquiry',
  subject text, priority text NOT NULL DEFAULT 'Low',
  message text NOT NULL, status text NOT NULL DEFAULT 'open',
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.contact_submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can submit contact" ON public.contact_submissions FOR INSERT WITH CHECK (
  CASE WHEN auth.uid() IS NOT NULL THEN user_id = auth.uid() OR user_id IS NULL ELSE user_id IS NULL END
);
CREATE POLICY "Users can view own submissions" ON public.contact_submissions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Admins can manage submissions" ON public.contact_submissions FOR ALL USING (public.has_role(auth.uid(), 'admin'));

-- Help reports
CREATE TABLE IF NOT EXISTS public.help_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid, report_type text NOT NULL,
  priority text NOT NULL DEFAULT 'low', description text NOT NULL,
  reference_id text, email text,
  status text NOT NULL DEFAULT 'open', created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.help_reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can submit reports" ON public.help_reports FOR INSERT WITH CHECK (
  CASE WHEN auth.uid() IS NOT NULL THEN user_id = auth.uid() OR user_id IS NULL ELSE user_id IS NULL END
);
CREATE POLICY "Users can view own reports" ON public.help_reports FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Admins can manage reports" ON public.help_reports FOR ALL USING (public.has_role(auth.uid(), 'admin'));

-- Feature requests + votes
CREATE TABLE IF NOT EXISTS public.feature_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL, description text NOT NULL DEFAULT '',
  category text NOT NULL DEFAULT 'tools', votes integer NOT NULL DEFAULT 0,
  comments integer NOT NULL DEFAULT 0, status text NOT NULL DEFAULT 'open',
  hot boolean NOT NULL DEFAULT false, icon text NOT NULL DEFAULT 'Zap',
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.feature_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Feature requests viewable by everyone" ON public.feature_requests FOR SELECT USING (true);
CREATE POLICY "Admins can manage feature requests" ON public.feature_requests FOR ALL USING (public.has_role(auth.uid(), 'admin'));

CREATE TABLE IF NOT EXISTS public.feature_votes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  feature_id uuid NOT NULL REFERENCES public.feature_requests(id) ON DELETE CASCADE,
  user_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(feature_id, user_id)
);
ALTER TABLE public.feature_votes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own votes" ON public.feature_votes FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Authenticated users can vote" ON public.feature_votes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can remove own votes" ON public.feature_votes FOR DELETE USING (auth.uid() = user_id);

-- Enterprise quotes
CREATE TABLE IF NOT EXISTS public.enterprise_quotes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_name text NOT NULL DEFAULT '', email text NOT NULL DEFAULT '',
  team_size text NOT NULL DEFAULT '', source text NOT NULL DEFAULT 'pricing',
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.enterprise_quotes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can submit quotes" ON public.enterprise_quotes FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view quotes" ON public.enterprise_quotes FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

-- Demo bookings
CREATE TABLE IF NOT EXISTS public.demo_bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL DEFAULT '', last_name text NOT NULL DEFAULT '',
  email text NOT NULL DEFAULT '', company_name text NOT NULL DEFAULT '',
  team_size text NOT NULL DEFAULT '', use_case text NOT NULL DEFAULT '',
  message text DEFAULT '', created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.demo_bookings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can submit demo bookings" ON public.demo_bookings FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view demo bookings" ON public.demo_bookings FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

-- Help feedback
CREATE TABLE IF NOT EXISTS public.help_feedback (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  rating text NOT NULL DEFAULT '', user_id uuid,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.help_feedback ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can submit feedback" ON public.help_feedback FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view feedback" ON public.help_feedback FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

-- Bug bounty
CREATE TABLE IF NOT EXISTS public.bug_bounty_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL UNIQUE, title text NOT NULL DEFAULT '',
  severity text NOT NULL DEFAULT 'low', status text NOT NULL DEFAULT 'open',
  description text NOT NULL DEFAULT '', user_id uuid,
  sp_reward integer DEFAULT 0, created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.bug_bounty_submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own bugs" ON public.bug_bounty_submissions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can submit bugs" ON public.bug_bounty_submissions FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);
CREATE POLICY "Admins can manage bugs" ON public.bug_bounty_submissions FOR ALL USING (public.has_role(auth.uid(), 'admin'));

-- Tournaments
CREATE TABLE IF NOT EXISTS public.tournaments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL, description text DEFAULT '',
  status text DEFAULT 'upcoming', max_participants integer DEFAULT 16,
  sp_prize integer DEFAULT 0, starts_at timestamptz,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.tournaments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Tournaments viewable by everyone" ON public.tournaments FOR SELECT USING (true);

CREATE TABLE IF NOT EXISTS public.tournament_participants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_id uuid REFERENCES public.tournaments(id) ON DELETE CASCADE,
  user_id uuid NOT NULL,
  created_at timestamptz DEFAULT now(),
  UNIQUE(tournament_id, user_id)
);
ALTER TABLE public.tournament_participants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Participants viewable by everyone" ON public.tournament_participants FOR SELECT USING (true);
CREATE POLICY "Users can join tournaments" ON public.tournament_participants FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Enterprise accounts
CREATE TABLE IF NOT EXISTS public.enterprise_accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL, owner_id uuid NOT NULL,
  logo_url text, plan text NOT NULL DEFAULT 'standard',
  max_seats integer NOT NULL DEFAULT 10,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.enterprise_accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enterprise members can view account" ON public.enterprise_accounts FOR SELECT TO authenticated USING (owner_id = auth.uid() OR public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Owner can manage account" ON public.enterprise_accounts FOR ALL TO authenticated USING (owner_id = auth.uid() OR public.has_role(auth.uid(), 'admin'));

CREATE TABLE IF NOT EXISTS public.enterprise_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id uuid NOT NULL REFERENCES public.enterprise_accounts(id) ON DELETE CASCADE,
  user_id uuid NOT NULL, role text NOT NULL DEFAULT 'member',
  invited_by uuid, created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(account_id, user_id)
);
ALTER TABLE public.enterprise_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view enterprise members" ON public.enterprise_members FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.enterprise_members em WHERE em.account_id = enterprise_members.account_id AND em.user_id = auth.uid())
  OR public.has_role(auth.uid(), 'admin')
);

-- Workspace consultations
CREATE TABLE IF NOT EXISTS public.workspace_consultations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id text NOT NULL, requested_by uuid NOT NULL,
  description text NOT NULL DEFAULT '', sp_offered integer NOT NULL DEFAULT 0,
  required_skills text[] DEFAULT '{}', status text NOT NULL DEFAULT 'open',
  consultant_id uuid, created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.workspace_consultations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own consultations" ON public.workspace_consultations FOR SELECT TO authenticated USING (requested_by = auth.uid() OR consultant_id = auth.uid());
CREATE POLICY "Users can create consultations" ON public.workspace_consultations FOR INSERT TO authenticated WITH CHECK (requested_by = auth.uid());

-- Workspace invites
CREATE TABLE IF NOT EXISTS public.workspace_invites (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id text NOT NULL,
  role text NOT NULL DEFAULT 'editor',
  token text NOT NULL UNIQUE DEFAULT encode(gen_random_bytes(32), 'hex'),
  created_by uuid NOT NULL,
  expires_at timestamptz NOT NULL DEFAULT (now() + interval '7 days'),
  used_by uuid, used_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.workspace_invites ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view invites" ON public.workspace_invites FOR SELECT TO authenticated USING (true);
CREATE POLICY "Members can create invites" ON public.workspace_invites FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by);
CREATE POLICY "Users can use invites" ON public.workspace_invites FOR UPDATE TO authenticated USING (used_by IS NULL AND expires_at > now()) WITH CHECK (auth.uid() = used_by);

-- Listing interactions
CREATE TABLE IF NOT EXISTS public.listing_interactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id uuid NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
  user_id uuid NOT NULL,
  interaction_type text NOT NULL CHECK (interaction_type IN ('like', 'save', 'share', 'report', 'view')),
  metadata jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  UNIQUE(listing_id, user_id, interaction_type)
);
ALTER TABLE public.listing_interactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read interactions" ON public.listing_interactions FOR SELECT USING (true);
CREATE POLICY "Users can insert interactions" ON public.listing_interactions FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own interactions" ON public.listing_interactions FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Enable realtime for messaging
ALTER PUBLICATION supabase_realtime ADD TABLE public.direct_messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.guild_channel_messages;

-- Indexes
CREATE INDEX IF NOT EXISTS idx_dm_conversation ON public.direct_messages(conversation_id, created_at);
CREATE INDEX IF NOT EXISTS idx_dm_sender ON public.direct_messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_conversations_p1 ON public.conversations(participant_one);
CREATE INDEX IF NOT EXISTS idx_conversations_p2 ON public.conversations(participant_two);
CREATE INDEX IF NOT EXISTS idx_guild_channels_guild ON public.guild_channels(guild_id);
CREATE INDEX IF NOT EXISTS idx_guild_messages_channel ON public.guild_channel_messages(channel_id, created_at);
CREATE INDEX IF NOT EXISTS idx_saved_posts_user_id ON public.saved_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_saved_posts_post_id ON public.saved_posts(post_id, post_type);
