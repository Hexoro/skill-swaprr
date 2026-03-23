
-- ═══════════════════════════════════════════════════════
-- Migration 3: Marketplace (listings, SP transactions, escrow, disputes)
-- ═══════════════════════════════════════════════════════

-- SP Transactions
CREATE TABLE IF NOT EXISTS public.sp_transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  amount integer NOT NULL,
  type text NOT NULL,
  description text DEFAULT '',
  reference_id uuid,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.sp_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own sp transactions" ON public.sp_transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "System can insert sp transactions" ON public.sp_transactions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Listings
CREATE TABLE IF NOT EXISTS public.listings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  title text NOT NULL,
  description text DEFAULT '',
  format text NOT NULL DEFAULT 'Direct',
  category text DEFAULT 'Other',
  skills_offered text[] DEFAULT '{}',
  skills_wanted text[] DEFAULT '{}',
  sp_price integer DEFAULT 0,
  delivery_time text DEFAULT '3 days',
  status text DEFAULT 'active',
  view_count integer DEFAULT 0,
  proposal_count integer DEFAULT 0,
  rating numeric DEFAULT 0,
  review_count integer DEFAULT 0,
  thumbnail_url text DEFAULT '',
  current_bid integer DEFAULT 0,
  bid_count integer DEFAULT 0,
  ends_at timestamptz,
  max_participants integer DEFAULT 1,
  current_participants integer DEFAULT 0,
  difficulty text DEFAULT 'Intermediate',
  tags text[] DEFAULT '{}',
  tiers jsonb DEFAULT NULL,
  images text[] DEFAULT '{}',
  gig_faq jsonb DEFAULT '[]',
  is_subscription boolean DEFAULT false,
  subscription_interval text DEFAULT NULL,
  revision_cost_sp integer DEFAULT 0,
  max_revisions integer DEFAULT 3,
  contest_config jsonb DEFAULT NULL,
  conditions jsonb DEFAULT NULL,
  roles_needed jsonb DEFAULT NULL,
  auction_config jsonb DEFAULT NULL,
  flash_config jsonb DEFAULT NULL,
  fusion_skills text[] DEFAULT '{}',
  requirements text[] DEFAULT '{}',
  completed_swaps integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE public.listings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Listings viewable by everyone" ON public.listings FOR SELECT USING (true);
CREATE POLICY "Users can create listings" ON public.listings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own listings" ON public.listings FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own listings" ON public.listings FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Admins can manage all listings" ON public.listings FOR ALL USING (public.has_role(auth.uid(), 'admin'));

-- Escrow contracts
CREATE TABLE IF NOT EXISTS public.escrow_contracts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id text,
  buyer_id uuid,
  seller_id uuid,
  listing_id uuid REFERENCES public.listings(id) ON DELETE SET NULL,
  total_sp integer NOT NULL DEFAULT 0,
  released_sp integer DEFAULT 0,
  status text DEFAULT 'pending',
  terms jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE public.escrow_contracts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Parties can view their contracts" ON public.escrow_contracts FOR SELECT USING (auth.uid() = buyer_id OR auth.uid() = seller_id);
CREATE POLICY "Buyers can create contracts" ON public.escrow_contracts FOR INSERT WITH CHECK (auth.uid() = buyer_id);
CREATE POLICY "Parties can update contracts" ON public.escrow_contracts FOR UPDATE USING (auth.uid() = buyer_id OR auth.uid() = seller_id);
CREATE POLICY "Admins can manage contracts" ON public.escrow_contracts FOR ALL USING (public.has_role(auth.uid(), 'admin'));

-- Disputes (Skill Court)
CREATE TABLE IF NOT EXISTS public.disputes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  filed_by uuid NOT NULL,
  filed_against uuid NOT NULL,
  escrow_id uuid REFERENCES public.escrow_contracts(id) ON DELETE SET NULL,
  title text NOT NULL,
  description text NOT NULL,
  status text DEFAULT 'open',
  verdict text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE public.disputes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Disputes viewable by parties and admins" ON public.disputes FOR SELECT USING (auth.uid() = filed_by OR auth.uid() = filed_against OR public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Users can file disputes" ON public.disputes FOR INSERT WITH CHECK (auth.uid() = filed_by);
CREATE POLICY "Admins can manage disputes" ON public.disputes FOR ALL USING (public.has_role(auth.uid(), 'admin'));

-- Case evidence
CREATE TABLE IF NOT EXISTS public.case_evidence (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  dispute_id uuid REFERENCES public.disputes(id) ON DELETE CASCADE NOT NULL,
  submitted_by uuid NOT NULL,
  type text DEFAULT 'text',
  content text NOT NULL,
  file_url text,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.case_evidence ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Evidence viewable by dispute parties" ON public.case_evidence FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.disputes d WHERE d.id = dispute_id AND (d.filed_by = auth.uid() OR d.filed_against = auth.uid()))
  OR public.has_role(auth.uid(), 'admin')
);
CREATE POLICY "Users can submit evidence" ON public.case_evidence FOR INSERT WITH CHECK (auth.uid() = submitted_by);

-- Case comments
CREATE TABLE IF NOT EXISTS public.case_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  dispute_id uuid REFERENCES public.disputes(id) ON DELETE CASCADE NOT NULL,
  user_id uuid NOT NULL,
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE public.case_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Case comments viewable by parties" ON public.case_comments FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.disputes d WHERE d.id = dispute_id AND (d.filed_by = auth.uid() OR d.filed_against = auth.uid()))
  OR public.has_role(auth.uid(), 'admin')
);
CREATE POLICY "Users can comment on cases" ON public.case_comments FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Jury
CREATE TABLE IF NOT EXISTS public.jury_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  dispute_id uuid REFERENCES public.disputes(id) ON DELETE CASCADE NOT NULL,
  user_id uuid NOT NULL,
  assigned_at timestamptz DEFAULT now()
);
ALTER TABLE public.jury_assignments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Jury can view assignments" ON public.jury_assignments FOR SELECT USING (auth.uid() = user_id OR public.has_role(auth.uid(), 'admin'));

CREATE TABLE IF NOT EXISTS public.jury_votes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  dispute_id uuid REFERENCES public.disputes(id) ON DELETE CASCADE NOT NULL,
  user_id uuid NOT NULL,
  vote text NOT NULL,
  reasoning text,
  created_at timestamptz DEFAULT now(),
  UNIQUE(dispute_id, user_id)
);
ALTER TABLE public.jury_votes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Jurors can view votes" ON public.jury_votes FOR SELECT USING (auth.uid() = user_id OR public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Jurors can cast votes" ON public.jury_votes FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_listings_user ON public.listings(user_id);
CREATE INDEX IF NOT EXISTS idx_listings_format ON public.listings(format);
CREATE INDEX IF NOT EXISTS idx_listings_status ON public.listings(status);
CREATE INDEX IF NOT EXISTS idx_listings_tags ON public.listings USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_escrow_buyer ON public.escrow_contracts(buyer_id);
CREATE INDEX IF NOT EXISTS idx_escrow_seller ON public.escrow_contracts(seller_id);
CREATE INDEX IF NOT EXISTS idx_disputes_filed_by ON public.disputes(filed_by);
CREATE INDEX IF NOT EXISTS idx_disputes_filed_against ON public.disputes(filed_against);
CREATE INDEX IF NOT EXISTS idx_sp_transactions_user ON public.sp_transactions(user_id);
