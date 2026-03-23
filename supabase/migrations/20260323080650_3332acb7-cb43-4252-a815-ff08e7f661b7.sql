
-- ═══════════════════════════════════════════════════════
-- Migration 5 (fixed): Workspaces, Transactions, Analytics
-- ═══════════════════════════════════════════════════════

-- Workspace members FIRST (no FK to workspaces initially)
CREATE TABLE IF NOT EXISTS public.workspace_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id text NOT NULL,
  user_id uuid NOT NULL,
  role text DEFAULT 'editor',
  joined_at timestamptz DEFAULT now(),
  UNIQUE(workspace_id, user_id)
);
ALTER TABLE public.workspace_members ENABLE ROW LEVEL SECURITY;

-- Workspaces
CREATE TABLE IF NOT EXISTS public.workspaces (
  id text PRIMARY KEY,
  title text NOT NULL DEFAULT 'Untitled Workspace',
  listing_id uuid REFERENCES public.listings(id) ON DELETE SET NULL,
  escrow_id uuid REFERENCES public.escrow_contracts(id) ON DELETE SET NULL,
  status text DEFAULT 'active',
  created_by uuid NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE public.workspaces ENABLE ROW LEVEL SECURITY;

-- Now add policies that reference both tables
CREATE POLICY "Workspace members can view" ON public.workspaces FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.workspace_members wm WHERE wm.workspace_id = workspaces.id AND wm.user_id = auth.uid())
  OR created_by = auth.uid()
);
CREATE POLICY "Users can create workspaces" ON public.workspaces FOR INSERT WITH CHECK (auth.uid() = created_by);
CREATE POLICY "Owners can update workspaces" ON public.workspaces FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Members can view workspace members" ON public.workspace_members FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.workspace_members wm WHERE wm.workspace_id = workspace_members.workspace_id AND wm.user_id = auth.uid())
);
CREATE POLICY "Users can join workspaces" ON public.workspace_members FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Workspace messages
CREATE TABLE IF NOT EXISTS public.workspace_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id text NOT NULL,
  sender_id uuid NOT NULL,
  content text NOT NULL,
  type text DEFAULT 'text',
  metadata jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.workspace_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view workspace messages" ON public.workspace_messages FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.workspace_members wm WHERE wm.workspace_id = workspace_messages.workspace_id AND wm.user_id = auth.uid())
);
CREATE POLICY "Members can send messages" ON public.workspace_messages FOR INSERT WITH CHECK (
  auth.uid() = sender_id AND
  EXISTS (SELECT 1 FROM public.workspace_members wm WHERE wm.workspace_id = workspace_messages.workspace_id AND wm.user_id = auth.uid())
);

-- Workspace stages
CREATE TABLE IF NOT EXISTS public.workspace_stages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id text NOT NULL,
  name text NOT NULL,
  description text DEFAULT '',
  status text DEFAULT 'pending',
  sp_allocated integer DEFAULT 0,
  order_index integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE public.workspace_stages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view stages" ON public.workspace_stages FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.workspace_members wm WHERE wm.workspace_id = workspace_stages.workspace_id AND wm.user_id = auth.uid())
);

-- Workspace files
CREATE TABLE IF NOT EXISTS public.workspace_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id text NOT NULL,
  uploaded_by uuid NOT NULL,
  name text NOT NULL,
  file_url text NOT NULL,
  file_type text DEFAULT '',
  file_size integer DEFAULT 0,
  notes text DEFAULT '',
  version integer DEFAULT 1,
  ai_quality_score numeric,
  ai_feedback text,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.workspace_files ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view workspace files" ON public.workspace_files FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.workspace_members wm WHERE wm.workspace_id = workspace_files.workspace_id AND wm.user_id = auth.uid())
);
CREATE POLICY "Members can upload files" ON public.workspace_files FOR INSERT WITH CHECK (
  auth.uid() = uploaded_by
);

-- Workspace deliverables
CREATE TABLE IF NOT EXISTS public.workspace_deliverables (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id text NOT NULL,
  stage_id uuid REFERENCES public.workspace_stages(id) ON DELETE SET NULL,
  title text NOT NULL,
  description text DEFAULT '',
  status text DEFAULT 'pending',
  file_id uuid REFERENCES public.workspace_files(id) ON DELETE SET NULL,
  approved_by uuid,
  approved_at timestamptz,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.workspace_deliverables ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view deliverables" ON public.workspace_deliverables FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.workspace_members wm WHERE wm.workspace_id = workspace_deliverables.workspace_id AND wm.user_id = auth.uid())
);

-- Transactions
CREATE TABLE IF NOT EXISTS public.transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL UNIQUE,
  workspace_id text,
  buyer_id uuid,
  seller_id uuid,
  listing_id uuid REFERENCES public.listings(id) ON DELETE SET NULL,
  total_sp integer DEFAULT 0,
  tax_sp integer DEFAULT 0,
  status text DEFAULT 'completed',
  metadata jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Parties can view transactions" ON public.transactions FOR SELECT USING (auth.uid() = buyer_id OR auth.uid() = seller_id OR public.has_role(auth.uid(), 'admin'));

-- Reviews
CREATE TABLE IF NOT EXISTS public.reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id uuid REFERENCES public.listings(id) ON DELETE CASCADE,
  reviewer_id uuid NOT NULL,
  reviewed_id uuid NOT NULL,
  workspace_id text,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  content text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Reviews viewable by everyone" ON public.reviews FOR SELECT USING (true);
CREATE POLICY "Users can create reviews" ON public.reviews FOR INSERT WITH CHECK (auth.uid() = reviewer_id);

-- Proposals
CREATE TABLE IF NOT EXISTS public.proposals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id uuid REFERENCES public.listings(id) ON DELETE CASCADE NOT NULL,
  sender_id uuid NOT NULL,
  receiver_id uuid NOT NULL,
  message text DEFAULT '',
  sp_amount integer DEFAULT 0,
  status text DEFAULT 'pending',
  requirements text,
  escrow_terms jsonb DEFAULT '{}',
  stage_config jsonb DEFAULT '[]',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE public.proposals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own proposals" ON public.proposals FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);
CREATE POLICY "Users can create proposals" ON public.proposals FOR INSERT WITH CHECK (auth.uid() = sender_id);
CREATE POLICY "Users can update proposals" ON public.proposals FOR UPDATE USING (auth.uid() = sender_id OR auth.uid() = receiver_id);
CREATE POLICY "Admins can manage proposals" ON public.proposals FOR ALL USING (public.has_role(auth.uid(), 'admin'));

-- Analytics tables
CREATE TABLE IF NOT EXISTS public.quarterly_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quarter text NOT NULL, year integer NOT NULL,
  data jsonb DEFAULT '{}', created_at timestamptz DEFAULT now()
);
ALTER TABLE public.quarterly_reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Reports viewable by admins" ON public.quarterly_reports FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

CREATE TABLE IF NOT EXISTS public.platform_metrics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  metric_name text NOT NULL, value numeric NOT NULL DEFAULT 0,
  period text DEFAULT 'daily', recorded_at timestamptz DEFAULT now()
);
ALTER TABLE public.platform_metrics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Metrics viewable by admins" ON public.platform_metrics FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

CREATE TABLE IF NOT EXISTS public.page_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid, page text NOT NULL, duration integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.page_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Sessions viewable by admins" ON public.page_sessions FOR SELECT USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Anyone can insert sessions" ON public.page_sessions FOR INSERT WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.click_heatmap (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  page text NOT NULL, x integer NOT NULL, y integer NOT NULL,
  element text, created_at timestamptz DEFAULT now()
);
ALTER TABLE public.click_heatmap ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Heatmap viewable by admins" ON public.click_heatmap FOR SELECT USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Anyone can insert heatmap" ON public.click_heatmap FOR INSERT WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.error_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid, error_message text NOT NULL, stack_trace text,
  page text, created_at timestamptz DEFAULT now()
);
ALTER TABLE public.error_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Errors viewable by admins" ON public.error_log FOR SELECT USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Anyone can log errors" ON public.error_log FOR INSERT WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.funnel_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid, step text NOT NULL, funnel text NOT NULL DEFAULT 'signup',
  metadata jsonb DEFAULT '{}', created_at timestamptz DEFAULT now()
);
ALTER TABLE public.funnel_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Funnels viewable by admins" ON public.funnel_events FOR SELECT USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Anyone can insert funnel events" ON public.funnel_events FOR INSERT WITH CHECK (true);

-- Enable realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.workspace_messages;

-- Indexes
CREATE INDEX IF NOT EXISTS idx_workspace_members_workspace ON public.workspace_members(workspace_id);
CREATE INDEX IF NOT EXISTS idx_workspace_members_user ON public.workspace_members(user_id);
CREATE INDEX IF NOT EXISTS idx_workspace_messages_workspace ON public.workspace_messages(workspace_id, created_at);
CREATE INDEX IF NOT EXISTS idx_proposals_listing ON public.proposals(listing_id);
CREATE INDEX IF NOT EXISTS idx_proposals_sender ON public.proposals(sender_id);
CREATE INDEX IF NOT EXISTS idx_proposals_receiver ON public.proposals(receiver_id);
CREATE INDEX IF NOT EXISTS idx_transactions_code ON public.transactions(code);

-- Triggers
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON public.reviews
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_proposals_updated_at BEFORE UPDATE ON public.proposals
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
