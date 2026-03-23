export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.4"
  }
  public: {
    Tables: {
      achievements: {
        Row: {
          category: string | null
          created_at: string | null
          description: string | null
          icon: string | null
          id: string
          name: string
          sp_reward: number | null
          threshold: number | null
        }
        Insert: {
          category?: string | null
          created_at?: string | null
          description?: string | null
          icon?: string | null
          id?: string
          name: string
          sp_reward?: number | null
          threshold?: number | null
        }
        Update: {
          category?: string | null
          created_at?: string | null
          description?: string | null
          icon?: string | null
          id?: string
          name?: string
          sp_reward?: number | null
          threshold?: number | null
        }
        Relationships: []
      }
      activity_log: {
        Row: {
          action: string
          created_at: string
          entity_id: string | null
          entity_type: string | null
          id: string
          ip_address: string | null
          metadata: Json | null
          user_agent: string | null
          user_id: string | null
        }
        Insert: {
          action: string
          created_at?: string
          entity_id?: string | null
          entity_type?: string | null
          id?: string
          ip_address?: string | null
          metadata?: Json | null
          user_agent?: string | null
          user_id?: string | null
        }
        Update: {
          action?: string
          created_at?: string
          entity_id?: string | null
          entity_type?: string | null
          id?: string
          ip_address?: string | null
          metadata?: Json | null
          user_agent?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
      badges: {
        Row: {
          category: string | null
          created_at: string | null
          description: string | null
          icon: string | null
          id: string
          name: string
          rarity: string | null
        }
        Insert: {
          category?: string | null
          created_at?: string | null
          description?: string | null
          icon?: string | null
          id?: string
          name: string
          rarity?: string | null
        }
        Update: {
          category?: string | null
          created_at?: string | null
          description?: string | null
          icon?: string | null
          id?: string
          name?: string
          rarity?: string | null
        }
        Relationships: []
      }
      blog_comments: {
        Row: {
          author_id: string | null
          author_name: string
          content: string
          created_at: string | null
          id: string
          like_count: number | null
          parent_id: string | null
          post_id: string
        }
        Insert: {
          author_id?: string | null
          author_name?: string
          content: string
          created_at?: string | null
          id?: string
          like_count?: number | null
          parent_id?: string | null
          post_id: string
        }
        Update: {
          author_id?: string | null
          author_name?: string
          content?: string
          created_at?: string | null
          id?: string
          like_count?: number | null
          parent_id?: string | null
          post_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "blog_comments_parent_id_fkey"
            columns: ["parent_id"]
            isOneToOne: false
            referencedRelation: "blog_comments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "blog_comments_post_id_fkey"
            columns: ["post_id"]
            isOneToOne: false
            referencedRelation: "blog_posts"
            referencedColumns: ["id"]
          },
        ]
      }
      blog_likes: {
        Row: {
          comment_id: string | null
          created_at: string | null
          id: string
          post_id: string | null
          user_id: string
        }
        Insert: {
          comment_id?: string | null
          created_at?: string | null
          id?: string
          post_id?: string | null
          user_id: string
        }
        Update: {
          comment_id?: string | null
          created_at?: string | null
          id?: string
          post_id?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "blog_likes_comment_id_fkey"
            columns: ["comment_id"]
            isOneToOne: false
            referencedRelation: "blog_comments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "blog_likes_post_id_fkey"
            columns: ["post_id"]
            isOneToOne: false
            referencedRelation: "blog_posts"
            referencedColumns: ["id"]
          },
        ]
      }
      blog_posts: {
        Row: {
          author_id: string | null
          author_name: string
          category: string
          comment_count: number | null
          content: Json
          cover_image: string | null
          created_at: string | null
          excerpt: string | null
          id: string
          is_featured: boolean | null
          is_published: boolean | null
          like_count: number | null
          read_time: number | null
          slug: string
          tags: string[] | null
          title: string
          updated_at: string | null
          view_count: number | null
        }
        Insert: {
          author_id?: string | null
          author_name?: string
          category?: string
          comment_count?: number | null
          content?: Json
          cover_image?: string | null
          created_at?: string | null
          excerpt?: string | null
          id?: string
          is_featured?: boolean | null
          is_published?: boolean | null
          like_count?: number | null
          read_time?: number | null
          slug: string
          tags?: string[] | null
          title: string
          updated_at?: string | null
          view_count?: number | null
        }
        Update: {
          author_id?: string | null
          author_name?: string
          category?: string
          comment_count?: number | null
          content?: Json
          cover_image?: string | null
          created_at?: string | null
          excerpt?: string | null
          id?: string
          is_featured?: boolean | null
          is_published?: boolean | null
          like_count?: number | null
          read_time?: number | null
          slug?: string
          tags?: string[] | null
          title?: string
          updated_at?: string | null
          view_count?: number | null
        }
        Relationships: []
      }
      bug_bounty_submissions: {
        Row: {
          code: string
          created_at: string
          description: string
          id: string
          reward: number | null
          severity: string
          sp_reward: number | null
          status: string
          submitted_by: string | null
          title: string
          user_id: string | null
        }
        Insert: {
          code: string
          created_at?: string
          description?: string
          id?: string
          reward?: number | null
          severity?: string
          sp_reward?: number | null
          status?: string
          submitted_by?: string | null
          title?: string
          user_id?: string | null
        }
        Update: {
          code?: string
          created_at?: string
          description?: string
          id?: string
          reward?: number | null
          severity?: string
          sp_reward?: number | null
          status?: string
          submitted_by?: string | null
          title?: string
          user_id?: string | null
        }
        Relationships: []
      }
      case_comments: {
        Row: {
          content: string
          created_at: string | null
          dispute_id: string
          id: string
          user_id: string
        }
        Insert: {
          content: string
          created_at?: string | null
          dispute_id: string
          id?: string
          user_id: string
        }
        Update: {
          content?: string
          created_at?: string | null
          dispute_id?: string
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "case_comments_dispute_id_fkey"
            columns: ["dispute_id"]
            isOneToOne: false
            referencedRelation: "disputes"
            referencedColumns: ["id"]
          },
        ]
      }
      case_evidence: {
        Row: {
          content: string
          created_at: string | null
          dispute_id: string
          file_url: string | null
          id: string
          submitted_by: string
          type: string | null
        }
        Insert: {
          content: string
          created_at?: string | null
          dispute_id: string
          file_url?: string | null
          id?: string
          submitted_by: string
          type?: string | null
        }
        Update: {
          content?: string
          created_at?: string | null
          dispute_id?: string
          file_url?: string | null
          id?: string
          submitted_by?: string
          type?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "case_evidence_dispute_id_fkey"
            columns: ["dispute_id"]
            isOneToOne: false
            referencedRelation: "disputes"
            referencedColumns: ["id"]
          },
        ]
      }
      click_heatmap: {
        Row: {
          created_at: string | null
          element: string | null
          id: string
          page: string
          x: number
          y: number
        }
        Insert: {
          created_at?: string | null
          element?: string | null
          id?: string
          page: string
          x: number
          y: number
        }
        Update: {
          created_at?: string | null
          element?: string | null
          id?: string
          page?: string
          x?: number
          y?: number
        }
        Relationships: []
      }
      contact_submissions: {
        Row: {
          created_at: string
          email: string
          id: string
          message: string
          name: string
          phone: string | null
          priority: string
          status: string
          subject: string | null
          topic: string
          user_id: string | null
        }
        Insert: {
          created_at?: string
          email: string
          id?: string
          message: string
          name: string
          phone?: string | null
          priority?: string
          status?: string
          subject?: string | null
          topic?: string
          user_id?: string | null
        }
        Update: {
          created_at?: string
          email?: string
          id?: string
          message?: string
          name?: string
          phone?: string | null
          priority?: string
          status?: string
          subject?: string | null
          topic?: string
          user_id?: string | null
        }
        Relationships: []
      }
      conversations: {
        Row: {
          created_at: string | null
          id: string
          last_message_at: string | null
          participant_one: string
          participant_two: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          last_message_at?: string | null
          participant_one: string
          participant_two: string
        }
        Update: {
          created_at?: string | null
          id?: string
          last_message_at?: string | null
          participant_one?: string
          participant_two?: string
        }
        Relationships: []
      }
      demo_bookings: {
        Row: {
          company_name: string
          created_at: string
          email: string
          first_name: string
          id: string
          last_name: string
          message: string | null
          team_size: string
          use_case: string
        }
        Insert: {
          company_name?: string
          created_at?: string
          email?: string
          first_name?: string
          id?: string
          last_name?: string
          message?: string | null
          team_size?: string
          use_case?: string
        }
        Update: {
          company_name?: string
          created_at?: string
          email?: string
          first_name?: string
          id?: string
          last_name?: string
          message?: string | null
          team_size?: string
          use_case?: string
        }
        Relationships: []
      }
      direct_messages: {
        Row: {
          content: string
          conversation_id: string
          created_at: string | null
          id: string
          is_read: boolean | null
          sender_id: string
        }
        Insert: {
          content: string
          conversation_id: string
          created_at?: string | null
          id?: string
          is_read?: boolean | null
          sender_id: string
        }
        Update: {
          content?: string
          conversation_id?: string
          created_at?: string | null
          id?: string
          is_read?: boolean | null
          sender_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "direct_messages_conversation_id_fkey"
            columns: ["conversation_id"]
            isOneToOne: false
            referencedRelation: "conversations"
            referencedColumns: ["id"]
          },
        ]
      }
      disputes: {
        Row: {
          created_at: string | null
          description: string
          escrow_id: string | null
          filed_against: string
          filed_by: string
          id: string
          status: string | null
          title: string
          updated_at: string | null
          verdict: string | null
        }
        Insert: {
          created_at?: string | null
          description: string
          escrow_id?: string | null
          filed_against: string
          filed_by: string
          id?: string
          status?: string | null
          title: string
          updated_at?: string | null
          verdict?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string
          escrow_id?: string | null
          filed_against?: string
          filed_by?: string
          id?: string
          status?: string | null
          title?: string
          updated_at?: string | null
          verdict?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "disputes_escrow_id_fkey"
            columns: ["escrow_id"]
            isOneToOne: false
            referencedRelation: "escrow_contracts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "disputes_filed_against_profiles_fkey"
            columns: ["filed_against"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "disputes_filed_against_profiles_fkey"
            columns: ["filed_against"]
            isOneToOne: false
            referencedRelation: "public_profiles"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "disputes_filed_by_profiles_fkey"
            columns: ["filed_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "disputes_filed_by_profiles_fkey"
            columns: ["filed_by"]
            isOneToOne: false
            referencedRelation: "public_profiles"
            referencedColumns: ["user_id"]
          },
        ]
      }
      enterprise_accounts: {
        Row: {
          created_at: string
          id: string
          logo_url: string | null
          max_seats: number
          name: string
          owner_id: string
          plan: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          logo_url?: string | null
          max_seats?: number
          name: string
          owner_id: string
          plan?: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          logo_url?: string | null
          max_seats?: number
          name?: string
          owner_id?: string
          plan?: string
          updated_at?: string
        }
        Relationships: []
      }
      enterprise_candidates: {
        Row: {
          account_id: string | null
          created_at: string | null
          id: string
          name: string
          skills: string[] | null
          status: string | null
          user_id: string | null
        }
        Insert: {
          account_id?: string | null
          created_at?: string | null
          id?: string
          name?: string
          skills?: string[] | null
          status?: string | null
          user_id?: string | null
        }
        Update: {
          account_id?: string | null
          created_at?: string | null
          id?: string
          name?: string
          skills?: string[] | null
          status?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "enterprise_candidates_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "enterprise_accounts"
            referencedColumns: ["id"]
          },
        ]
      }
      enterprise_consultations: {
        Row: {
          created_at: string | null
          description: string | null
          enterprise_id: string | null
          id: string
          status: string | null
          title: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          enterprise_id?: string | null
          id?: string
          status?: string | null
          title?: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          enterprise_id?: string | null
          id?: string
          status?: string | null
          title?: string
        }
        Relationships: []
      }
      enterprise_members: {
        Row: {
          account_id: string
          created_at: string
          id: string
          invited_by: string | null
          role: string
          user_id: string
        }
        Insert: {
          account_id: string
          created_at?: string
          id?: string
          invited_by?: string | null
          role?: string
          user_id: string
        }
        Update: {
          account_id?: string
          created_at?: string
          id?: string
          invited_by?: string | null
          role?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "enterprise_members_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "enterprise_accounts"
            referencedColumns: ["id"]
          },
        ]
      }
      enterprise_projects: {
        Row: {
          budget_sp: number | null
          created_at: string | null
          created_by: string | null
          description: string | null
          id: string
          name: string
          status: string | null
        }
        Insert: {
          budget_sp?: number | null
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          id?: string
          name: string
          status?: string | null
        }
        Update: {
          budget_sp?: number | null
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          id?: string
          name?: string
          status?: string | null
        }
        Relationships: []
      }
      enterprise_quotes: {
        Row: {
          company_name: string
          created_at: string
          email: string
          id: string
          source: string
          team_size: string
        }
        Insert: {
          company_name?: string
          created_at?: string
          email?: string
          id?: string
          source?: string
          team_size?: string
        }
        Update: {
          company_name?: string
          created_at?: string
          email?: string
          id?: string
          source?: string
          team_size?: string
        }
        Relationships: []
      }
      error_log: {
        Row: {
          created_at: string | null
          error_message: string
          id: string
          page: string | null
          stack_trace: string | null
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          error_message: string
          id?: string
          page?: string | null
          stack_trace?: string | null
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          error_message?: string
          id?: string
          page?: string | null
          stack_trace?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
      escrow_contracts: {
        Row: {
          buyer_id: string | null
          created_at: string | null
          id: string
          listing_id: string | null
          released_sp: number | null
          seller_id: string | null
          status: string | null
          terms: Json | null
          total_sp: number
          updated_at: string | null
          workspace_id: string | null
        }
        Insert: {
          buyer_id?: string | null
          created_at?: string | null
          id?: string
          listing_id?: string | null
          released_sp?: number | null
          seller_id?: string | null
          status?: string | null
          terms?: Json | null
          total_sp?: number
          updated_at?: string | null
          workspace_id?: string | null
        }
        Update: {
          buyer_id?: string | null
          created_at?: string | null
          id?: string
          listing_id?: string | null
          released_sp?: number | null
          seller_id?: string | null
          status?: string | null
          terms?: Json | null
          total_sp?: number
          updated_at?: string | null
          workspace_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "escrow_contracts_listing_id_fkey"
            columns: ["listing_id"]
            isOneToOne: false
            referencedRelation: "listings"
            referencedColumns: ["id"]
          },
        ]
      }
      event_registrations: {
        Row: {
          event_id: string
          id: string
          registered_at: string
          status: string | null
          user_id: string
        }
        Insert: {
          event_id: string
          id?: string
          registered_at?: string
          status?: string | null
          user_id: string
        }
        Update: {
          event_id?: string
          id?: string
          registered_at?: string
          status?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "event_registrations_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: false
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
        ]
      }
      events: {
        Row: {
          address: string
          background_image_url: string
          category: string | null
          created_by: string
          creator: string
          date: string
          description: string
          event_date: string | null
          id: string
          image_url: string | null
          location: string | null
          max_spots: number | null
          organizer_id: string | null
          organizer_name: string | null
          spots_filled: number | null
          status: string | null
          target_date: string
          time: string
          title: string
        }
        Insert: {
          address: string
          background_image_url: string
          category?: string | null
          created_by?: string
          creator: string
          date: string
          description: string
          event_date?: string | null
          id?: string
          image_url?: string | null
          location?: string | null
          max_spots?: number | null
          organizer_id?: string | null
          organizer_name?: string | null
          spots_filled?: number | null
          status?: string | null
          target_date: string
          time: string
          title: string
        }
        Update: {
          address?: string
          background_image_url?: string
          category?: string | null
          created_by?: string
          creator?: string
          date?: string
          description?: string
          event_date?: string | null
          id?: string
          image_url?: string | null
          location?: string | null
          max_spots?: number | null
          organizer_id?: string | null
          organizer_name?: string | null
          spots_filled?: number | null
          status?: string | null
          target_date?: string
          time?: string
          title?: string
        }
        Relationships: []
      }
      feature_requests: {
        Row: {
          category: string
          comments: number
          created_at: string
          description: string
          hot: boolean
          icon: string
          id: string
          status: string
          title: string
          votes: number
        }
        Insert: {
          category?: string
          comments?: number
          created_at?: string
          description?: string
          hot?: boolean
          icon?: string
          id?: string
          status?: string
          title: string
          votes?: number
        }
        Update: {
          category?: string
          comments?: number
          created_at?: string
          description?: string
          hot?: boolean
          icon?: string
          id?: string
          status?: string
          title?: string
          votes?: number
        }
        Relationships: []
      }
      feature_votes: {
        Row: {
          created_at: string
          feature_id: string
          id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          feature_id: string
          id?: string
          user_id: string
        }
        Update: {
          created_at?: string
          feature_id?: string
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "feature_votes_feature_id_fkey"
            columns: ["feature_id"]
            isOneToOne: false
            referencedRelation: "feature_requests"
            referencedColumns: ["id"]
          },
        ]
      }
      forum_categories: {
        Row: {
          color: string | null
          created_at: string | null
          description: string | null
          icon: string | null
          id: string
          name: string
          slug: string
          thread_count: number | null
        }
        Insert: {
          color?: string | null
          created_at?: string | null
          description?: string | null
          icon?: string | null
          id?: string
          name: string
          slug: string
          thread_count?: number | null
        }
        Update: {
          color?: string | null
          created_at?: string | null
          description?: string | null
          icon?: string | null
          id?: string
          name?: string
          slug?: string
          thread_count?: number | null
        }
        Relationships: []
      }
      forum_comments: {
        Row: {
          author_id: string | null
          author_name: string
          content: string
          created_at: string | null
          downvotes: number | null
          id: string
          parent_id: string | null
          thread_id: string
          updated_at: string | null
          upvotes: number | null
        }
        Insert: {
          author_id?: string | null
          author_name?: string
          content: string
          created_at?: string | null
          downvotes?: number | null
          id?: string
          parent_id?: string | null
          thread_id: string
          updated_at?: string | null
          upvotes?: number | null
        }
        Update: {
          author_id?: string | null
          author_name?: string
          content?: string
          created_at?: string | null
          downvotes?: number | null
          id?: string
          parent_id?: string | null
          thread_id?: string
          updated_at?: string | null
          upvotes?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "forum_comments_parent_id_fkey"
            columns: ["parent_id"]
            isOneToOne: false
            referencedRelation: "forum_comments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "forum_comments_thread_id_fkey"
            columns: ["thread_id"]
            isOneToOne: false
            referencedRelation: "forum_threads"
            referencedColumns: ["id"]
          },
        ]
      }
      forum_threads: {
        Row: {
          author_id: string | null
          author_name: string
          category_id: string | null
          comment_count: number | null
          content: string
          created_at: string | null
          downvotes: number | null
          id: string
          is_locked: boolean | null
          is_pinned: boolean | null
          tags: string[] | null
          title: string
          updated_at: string | null
          upvotes: number | null
          view_count: number | null
        }
        Insert: {
          author_id?: string | null
          author_name?: string
          category_id?: string | null
          comment_count?: number | null
          content: string
          created_at?: string | null
          downvotes?: number | null
          id?: string
          is_locked?: boolean | null
          is_pinned?: boolean | null
          tags?: string[] | null
          title: string
          updated_at?: string | null
          upvotes?: number | null
          view_count?: number | null
        }
        Update: {
          author_id?: string | null
          author_name?: string
          category_id?: string | null
          comment_count?: number | null
          content?: string
          created_at?: string | null
          downvotes?: number | null
          id?: string
          is_locked?: boolean | null
          is_pinned?: boolean | null
          tags?: string[] | null
          title?: string
          updated_at?: string | null
          upvotes?: number | null
          view_count?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "forum_threads_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "forum_categories"
            referencedColumns: ["id"]
          },
        ]
      }
      forum_votes: {
        Row: {
          comment_id: string | null
          created_at: string | null
          id: string
          thread_id: string | null
          user_id: string
          vote_type: number
        }
        Insert: {
          comment_id?: string | null
          created_at?: string | null
          id?: string
          thread_id?: string | null
          user_id: string
          vote_type: number
        }
        Update: {
          comment_id?: string | null
          created_at?: string | null
          id?: string
          thread_id?: string | null
          user_id?: string
          vote_type?: number
        }
        Relationships: [
          {
            foreignKeyName: "forum_votes_comment_id_fkey"
            columns: ["comment_id"]
            isOneToOne: false
            referencedRelation: "forum_comments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "forum_votes_thread_id_fkey"
            columns: ["thread_id"]
            isOneToOne: false
            referencedRelation: "forum_threads"
            referencedColumns: ["id"]
          },
        ]
      }
      funnel_events: {
        Row: {
          created_at: string | null
          funnel: string
          id: string
          metadata: Json | null
          step: string
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          funnel?: string
          id?: string
          metadata?: Json | null
          step: string
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          funnel?: string
          id?: string
          metadata?: Json | null
          step?: string
          user_id?: string | null
        }
        Relationships: []
      }
      guild_achievements: {
        Row: {
          achievement_id: string
          completed: boolean | null
          completed_at: string | null
          guild_id: string
          id: string
          progress: number | null
        }
        Insert: {
          achievement_id: string
          completed?: boolean | null
          completed_at?: string | null
          guild_id: string
          id?: string
          progress?: number | null
        }
        Update: {
          achievement_id?: string
          completed?: boolean | null
          completed_at?: string | null
          guild_id?: string
          id?: string
          progress?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "guild_achievements_achievement_id_fkey"
            columns: ["achievement_id"]
            isOneToOne: false
            referencedRelation: "achievements"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "guild_achievements_guild_id_fkey"
            columns: ["guild_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
        ]
      }
      guild_badges: {
        Row: {
          badge_id: string
          earned_at: string | null
          guild_id: string
          id: string
        }
        Insert: {
          badge_id: string
          earned_at?: string | null
          guild_id: string
          id?: string
        }
        Update: {
          badge_id?: string
          earned_at?: string | null
          guild_id?: string
          id?: string
        }
        Relationships: [
          {
            foreignKeyName: "guild_badges_badge_id_fkey"
            columns: ["badge_id"]
            isOneToOne: false
            referencedRelation: "badges"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "guild_badges_guild_id_fkey"
            columns: ["guild_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
        ]
      }
      guild_channel_messages: {
        Row: {
          channel_id: string
          content: string
          created_at: string | null
          id: string
          sender_id: string
        }
        Insert: {
          channel_id: string
          content: string
          created_at?: string | null
          id?: string
          sender_id: string
        }
        Update: {
          channel_id?: string
          content?: string
          created_at?: string | null
          id?: string
          sender_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "guild_channel_messages_channel_id_fkey"
            columns: ["channel_id"]
            isOneToOne: false
            referencedRelation: "guild_channels"
            referencedColumns: ["id"]
          },
        ]
      }
      guild_channels: {
        Row: {
          created_at: string | null
          description: string | null
          guild_id: string
          id: string
          name: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          guild_id: string
          id?: string
          name?: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          guild_id?: string
          id?: string
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: "guild_channels_guild_id_fkey"
            columns: ["guild_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
        ]
      }
      guild_loans: {
        Row: {
          amount: number
          borrower_id: string
          created_at: string | null
          guild_id: string
          id: string
          status: string | null
        }
        Insert: {
          amount: number
          borrower_id: string
          created_at?: string | null
          guild_id: string
          id?: string
          status?: string | null
        }
        Update: {
          amount?: number
          borrower_id?: string
          created_at?: string | null
          guild_id?: string
          id?: string
          status?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "guild_loans_guild_id_fkey"
            columns: ["guild_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
        ]
      }
      guild_members: {
        Row: {
          guild_id: string
          id: string
          joined_at: string | null
          role: string | null
          user_id: string
        }
        Insert: {
          guild_id: string
          id?: string
          joined_at?: string | null
          role?: string | null
          user_id: string
        }
        Update: {
          guild_id?: string
          id?: string
          joined_at?: string | null
          role?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "guild_members_guild_id_fkey"
            columns: ["guild_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "guild_members_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "guild_members_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "public_profiles"
            referencedColumns: ["user_id"]
          },
        ]
      }
      guild_projects: {
        Row: {
          created_at: string | null
          description: string | null
          guild_id: string
          id: string
          sp_budget: number | null
          status: string | null
          title: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          guild_id: string
          id?: string
          sp_budget?: number | null
          status?: string | null
          title: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          guild_id?: string
          id?: string
          sp_budget?: number | null
          status?: string | null
          title?: string
        }
        Relationships: [
          {
            foreignKeyName: "guild_projects_guild_id_fkey"
            columns: ["guild_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
        ]
      }
      guild_treasury_log: {
        Row: {
          amount: number
          created_at: string | null
          description: string | null
          guild_id: string
          id: string
          type: string
        }
        Insert: {
          amount: number
          created_at?: string | null
          description?: string | null
          guild_id: string
          id?: string
          type: string
        }
        Update: {
          amount?: number
          created_at?: string | null
          description?: string | null
          guild_id?: string
          id?: string
          type?: string
        }
        Relationships: [
          {
            foreignKeyName: "guild_treasury_log_guild_id_fkey"
            columns: ["guild_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
        ]
      }
      guild_wars: {
        Row: {
          challenger_id: string | null
          created_at: string | null
          defender_id: string | null
          id: string
          status: string | null
          winner_id: string | null
        }
        Insert: {
          challenger_id?: string | null
          created_at?: string | null
          defender_id?: string | null
          id?: string
          status?: string | null
          winner_id?: string | null
        }
        Update: {
          challenger_id?: string | null
          created_at?: string | null
          defender_id?: string | null
          id?: string
          status?: string | null
          winner_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "guild_wars_challenger_id_fkey"
            columns: ["challenger_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "guild_wars_defender_id_fkey"
            columns: ["defender_id"]
            isOneToOne: false
            referencedRelation: "guilds"
            referencedColumns: ["id"]
          },
        ]
      }
      guilds: {
        Row: {
          banner_url: string | null
          category: string | null
          created_at: string | null
          created_by: string
          description: string | null
          guild_sections: Json | null
          id: string
          is_public: boolean | null
          level: number | null
          logo_url: string | null
          max_members: number | null
          member_count: number | null
          name: string
          treasury_sp: number | null
          updated_at: string | null
          xp: number | null
        }
        Insert: {
          banner_url?: string | null
          category?: string | null
          created_at?: string | null
          created_by: string
          description?: string | null
          guild_sections?: Json | null
          id?: string
          is_public?: boolean | null
          level?: number | null
          logo_url?: string | null
          max_members?: number | null
          member_count?: number | null
          name: string
          treasury_sp?: number | null
          updated_at?: string | null
          xp?: number | null
        }
        Update: {
          banner_url?: string | null
          category?: string | null
          created_at?: string | null
          created_by?: string
          description?: string | null
          guild_sections?: Json | null
          id?: string
          is_public?: boolean | null
          level?: number | null
          logo_url?: string | null
          max_members?: number | null
          member_count?: number | null
          name?: string
          treasury_sp?: number | null
          updated_at?: string | null
          xp?: number | null
        }
        Relationships: []
      }
      help_articles: {
        Row: {
          category: string | null
          content: string
          created_at: string | null
          id: string
          slug: string | null
          title: string
        }
        Insert: {
          category?: string | null
          content?: string
          created_at?: string | null
          id?: string
          slug?: string | null
          title: string
        }
        Update: {
          category?: string | null
          content?: string
          created_at?: string | null
          id?: string
          slug?: string | null
          title?: string
        }
        Relationships: []
      }
      help_feedback: {
        Row: {
          created_at: string
          id: string
          rating: string
          user_id: string | null
        }
        Insert: {
          created_at?: string
          id?: string
          rating?: string
          user_id?: string | null
        }
        Update: {
          created_at?: string
          id?: string
          rating?: string
          user_id?: string | null
        }
        Relationships: []
      }
      help_reports: {
        Row: {
          created_at: string
          description: string
          email: string | null
          id: string
          priority: string
          reference_id: string | null
          report_type: string
          status: string
          user_id: string | null
        }
        Insert: {
          created_at?: string
          description: string
          email?: string | null
          id?: string
          priority?: string
          reference_id?: string | null
          report_type: string
          status?: string
          user_id?: string | null
        }
        Update: {
          created_at?: string
          description?: string
          email?: string | null
          id?: string
          priority?: string
          reference_id?: string | null
          report_type?: string
          status?: string
          user_id?: string | null
        }
        Relationships: []
      }
      jury_assignments: {
        Row: {
          assigned_at: string | null
          dispute_id: string
          id: string
          status: string | null
          user_id: string
        }
        Insert: {
          assigned_at?: string | null
          dispute_id: string
          id?: string
          status?: string | null
          user_id: string
        }
        Update: {
          assigned_at?: string | null
          dispute_id?: string
          id?: string
          status?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "jury_assignments_dispute_id_fkey"
            columns: ["dispute_id"]
            isOneToOne: false
            referencedRelation: "disputes"
            referencedColumns: ["id"]
          },
        ]
      }
      jury_votes: {
        Row: {
          created_at: string | null
          dispute_id: string
          id: string
          reasoning: string | null
          user_id: string
          vote: string
        }
        Insert: {
          created_at?: string | null
          dispute_id: string
          id?: string
          reasoning?: string | null
          user_id: string
          vote: string
        }
        Update: {
          created_at?: string | null
          dispute_id?: string
          id?: string
          reasoning?: string | null
          user_id?: string
          vote?: string
        }
        Relationships: [
          {
            foreignKeyName: "jury_votes_dispute_id_fkey"
            columns: ["dispute_id"]
            isOneToOne: false
            referencedRelation: "disputes"
            referencedColumns: ["id"]
          },
        ]
      }
      listing_interactions: {
        Row: {
          created_at: string | null
          id: string
          interaction_type: string
          listing_id: string
          metadata: Json | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          interaction_type: string
          listing_id: string
          metadata?: Json | null
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          interaction_type?: string
          listing_id?: string
          metadata?: Json | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "listing_interactions_listing_id_fkey"
            columns: ["listing_id"]
            isOneToOne: false
            referencedRelation: "listings"
            referencedColumns: ["id"]
          },
        ]
      }
      listings: {
        Row: {
          auction_config: Json | null
          bid_count: number | null
          category: string | null
          completed_swaps: number | null
          conditions: Json | null
          contest_config: Json | null
          created_at: string | null
          current_bid: number | null
          current_participants: number | null
          delivery_time: string | null
          description: string | null
          difficulty: string | null
          ends_at: string | null
          flash_config: Json | null
          format: string
          fusion_skills: string[] | null
          gig_faq: Json | null
          id: string
          images: string[] | null
          is_subscription: boolean | null
          max_participants: number | null
          max_revisions: number | null
          points: number | null
          price: number | null
          proposal_count: number | null
          rating: number | null
          requirements: string[] | null
          review_count: number | null
          revision_cost_sp: number | null
          roles_needed: Json | null
          skills_offered: string[] | null
          skills_wanted: string[] | null
          sp_price: number | null
          status: string | null
          subscription_interval: string | null
          tags: string[] | null
          thumbnail_url: string | null
          tiers: Json | null
          title: string
          updated_at: string | null
          user_id: string
          view_count: number | null
          views: number | null
        }
        Insert: {
          auction_config?: Json | null
          bid_count?: number | null
          category?: string | null
          completed_swaps?: number | null
          conditions?: Json | null
          contest_config?: Json | null
          created_at?: string | null
          current_bid?: number | null
          current_participants?: number | null
          delivery_time?: string | null
          description?: string | null
          difficulty?: string | null
          ends_at?: string | null
          flash_config?: Json | null
          format?: string
          fusion_skills?: string[] | null
          gig_faq?: Json | null
          id?: string
          images?: string[] | null
          is_subscription?: boolean | null
          max_participants?: number | null
          max_revisions?: number | null
          points?: number | null
          price?: number | null
          proposal_count?: number | null
          rating?: number | null
          requirements?: string[] | null
          review_count?: number | null
          revision_cost_sp?: number | null
          roles_needed?: Json | null
          skills_offered?: string[] | null
          skills_wanted?: string[] | null
          sp_price?: number | null
          status?: string | null
          subscription_interval?: string | null
          tags?: string[] | null
          thumbnail_url?: string | null
          tiers?: Json | null
          title: string
          updated_at?: string | null
          user_id: string
          view_count?: number | null
          views?: number | null
        }
        Update: {
          auction_config?: Json | null
          bid_count?: number | null
          category?: string | null
          completed_swaps?: number | null
          conditions?: Json | null
          contest_config?: Json | null
          created_at?: string | null
          current_bid?: number | null
          current_participants?: number | null
          delivery_time?: string | null
          description?: string | null
          difficulty?: string | null
          ends_at?: string | null
          flash_config?: Json | null
          format?: string
          fusion_skills?: string[] | null
          gig_faq?: Json | null
          id?: string
          images?: string[] | null
          is_subscription?: boolean | null
          max_participants?: number | null
          max_revisions?: number | null
          points?: number | null
          price?: number | null
          proposal_count?: number | null
          rating?: number | null
          requirements?: string[] | null
          review_count?: number | null
          revision_cost_sp?: number | null
          roles_needed?: Json | null
          skills_offered?: string[] | null
          skills_wanted?: string[] | null
          sp_price?: number | null
          status?: string | null
          subscription_interval?: string | null
          tags?: string[] | null
          thumbnail_url?: string | null
          tiers?: Json | null
          title?: string
          updated_at?: string | null
          user_id?: string
          view_count?: number | null
          views?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "listings_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "listings_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "public_profiles"
            referencedColumns: ["user_id"]
          },
        ]
      }
      newsletter_subscriptions: {
        Row: {
          created_at: string
          email: string
          id: string
        }
        Insert: {
          created_at?: string
          email: string
          id?: string
        }
        Update: {
          created_at?: string
          email?: string
          id?: string
        }
        Relationships: []
      }
      notifications: {
        Row: {
          created_at: string | null
          id: string
          is_read: boolean | null
          link: string | null
          message: string | null
          title: string
          type: string
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          is_read?: boolean | null
          link?: string | null
          message?: string | null
          title: string
          type?: string
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          is_read?: boolean | null
          link?: string | null
          message?: string | null
          title?: string
          type?: string
          user_id?: string
        }
        Relationships: []
      }
      page_sessions: {
        Row: {
          created_at: string | null
          duration: number | null
          duration_seconds: number | null
          id: string
          page: string
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          duration?: number | null
          duration_seconds?: number | null
          id?: string
          page: string
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          duration?: number | null
          duration_seconds?: number | null
          id?: string
          page?: string
          user_id?: string | null
        }
        Relationships: []
      }
      platform_metrics: {
        Row: {
          id: string
          metric_name: string
          period: string | null
          recorded_at: string | null
          value: number
        }
        Insert: {
          id?: string
          metric_name: string
          period?: string | null
          recorded_at?: string | null
          value?: number
        }
        Update: {
          id?: string
          metric_name?: string
          period?: string | null
          recorded_at?: string | null
          value?: number
        }
        Relationships: []
      }
      profiles: {
        Row: {
          availability: string | null
          avatar_emoji: string | null
          avatar_url: string | null
          badges: Json | null
          bio: string | null
          certificates: Json | null
          created_at: string
          display_name: string | null
          display_theme: string | null
          education_history: Json | null
          elo: number
          email: string
          full_name: string
          github_url: string | null
          hourly_rate: string | null
          id: string
          id_verified: boolean | null
          instagram_url: string | null
          interests: string[] | null
          languages: string[] | null
          linkedin_url: string | null
          location: string | null
          needs: string[] | null
          onboarding_complete: boolean | null
          personal_website: string | null
          portfolio_items: Json | null
          portfolio_url: string | null
          preferred_comm: string | null
          referral_code: string | null
          referred_by: string | null
          response_time: string | null
          skill_levels: Json | null
          skills: string[] | null
          slogan: string | null
          sp: number
          streak_days: number | null
          tier: string
          timezone: string | null
          total_gigs_completed: number | null
          twitter_url: string | null
          university: string | null
          updated_at: string
          user_id: string
          work_history: Json | null
          youtube_url: string | null
        }
        Insert: {
          availability?: string | null
          avatar_emoji?: string | null
          avatar_url?: string | null
          badges?: Json | null
          bio?: string | null
          certificates?: Json | null
          created_at?: string
          display_name?: string | null
          display_theme?: string | null
          education_history?: Json | null
          elo?: number
          email?: string
          full_name?: string
          github_url?: string | null
          hourly_rate?: string | null
          id?: string
          id_verified?: boolean | null
          instagram_url?: string | null
          interests?: string[] | null
          languages?: string[] | null
          linkedin_url?: string | null
          location?: string | null
          needs?: string[] | null
          onboarding_complete?: boolean | null
          personal_website?: string | null
          portfolio_items?: Json | null
          portfolio_url?: string | null
          preferred_comm?: string | null
          referral_code?: string | null
          referred_by?: string | null
          response_time?: string | null
          skill_levels?: Json | null
          skills?: string[] | null
          slogan?: string | null
          sp?: number
          streak_days?: number | null
          tier?: string
          timezone?: string | null
          total_gigs_completed?: number | null
          twitter_url?: string | null
          university?: string | null
          updated_at?: string
          user_id: string
          work_history?: Json | null
          youtube_url?: string | null
        }
        Update: {
          availability?: string | null
          avatar_emoji?: string | null
          avatar_url?: string | null
          badges?: Json | null
          bio?: string | null
          certificates?: Json | null
          created_at?: string
          display_name?: string | null
          display_theme?: string | null
          education_history?: Json | null
          elo?: number
          email?: string
          full_name?: string
          github_url?: string | null
          hourly_rate?: string | null
          id?: string
          id_verified?: boolean | null
          instagram_url?: string | null
          interests?: string[] | null
          languages?: string[] | null
          linkedin_url?: string | null
          location?: string | null
          needs?: string[] | null
          onboarding_complete?: boolean | null
          personal_website?: string | null
          portfolio_items?: Json | null
          portfolio_url?: string | null
          preferred_comm?: string | null
          referral_code?: string | null
          referred_by?: string | null
          response_time?: string | null
          skill_levels?: Json | null
          skills?: string[] | null
          slogan?: string | null
          sp?: number
          streak_days?: number | null
          tier?: string
          timezone?: string | null
          total_gigs_completed?: number | null
          twitter_url?: string | null
          university?: string | null
          updated_at?: string
          user_id?: string
          work_history?: Json | null
          youtube_url?: string | null
        }
        Relationships: []
      }
      proposals: {
        Row: {
          created_at: string | null
          escrow_terms: Json | null
          id: string
          listing_id: string
          message: string | null
          receiver_id: string
          requirements: string | null
          sender_id: string
          sp_amount: number | null
          stage_config: Json | null
          status: string | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          escrow_terms?: Json | null
          id?: string
          listing_id: string
          message?: string | null
          receiver_id: string
          requirements?: string | null
          sender_id: string
          sp_amount?: number | null
          stage_config?: Json | null
          status?: string | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          escrow_terms?: Json | null
          id?: string
          listing_id?: string
          message?: string | null
          receiver_id?: string
          requirements?: string | null
          sender_id?: string
          sp_amount?: number | null
          stage_config?: Json | null
          status?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "proposals_listing_id_fkey"
            columns: ["listing_id"]
            isOneToOne: false
            referencedRelation: "listings"
            referencedColumns: ["id"]
          },
        ]
      }
      quarterly_reports: {
        Row: {
          created_at: string | null
          data: Json | null
          id: string
          quarter: string
          year: number
        }
        Insert: {
          created_at?: string | null
          data?: Json | null
          id?: string
          quarter: string
          year: number
        }
        Update: {
          created_at?: string | null
          data?: Json | null
          id?: string
          quarter?: string
          year?: number
        }
        Relationships: []
      }
      ranking_history: {
        Row: {
          created_at: string | null
          elo: number
          id: string
          reason: string | null
          tier: string
          user_id: string
        }
        Insert: {
          created_at?: string | null
          elo: number
          id?: string
          reason?: string | null
          tier: string
          user_id: string
        }
        Update: {
          created_at?: string | null
          elo?: number
          id?: string
          reason?: string | null
          tier?: string
          user_id?: string
        }
        Relationships: []
      }
      reviews: {
        Row: {
          content: string | null
          created_at: string | null
          id: string
          listing_id: string | null
          rating: number
          reviewed_id: string
          reviewer_id: string
          updated_at: string | null
          workspace_id: string | null
        }
        Insert: {
          content?: string | null
          created_at?: string | null
          id?: string
          listing_id?: string | null
          rating: number
          reviewed_id: string
          reviewer_id: string
          updated_at?: string | null
          workspace_id?: string | null
        }
        Update: {
          content?: string | null
          created_at?: string | null
          id?: string
          listing_id?: string | null
          rating?: number
          reviewed_id?: string
          reviewer_id?: string
          updated_at?: string | null
          workspace_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "reviews_listing_id_fkey"
            columns: ["listing_id"]
            isOneToOne: false
            referencedRelation: "listings"
            referencedColumns: ["id"]
          },
        ]
      }
      saved_posts: {
        Row: {
          created_at: string
          id: string
          post_id: string
          post_type: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          post_id: string
          post_type: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          post_id?: string
          post_type?: string
          user_id?: string
        }
        Relationships: []
      }
      service_incidents: {
        Row: {
          created_at: string | null
          description: string | null
          id: string
          service_id: string | null
          severity: string | null
          status: string | null
          title: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          id?: string
          service_id?: string | null
          severity?: string | null
          status?: string | null
          title: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          id?: string
          service_id?: string | null
          severity?: string | null
          status?: string | null
          title?: string
        }
        Relationships: [
          {
            foreignKeyName: "service_incidents_service_id_fkey"
            columns: ["service_id"]
            isOneToOne: false
            referencedRelation: "service_status"
            referencedColumns: ["id"]
          },
        ]
      }
      service_status: {
        Row: {
          created_at: string | null
          id: string
          service_name: string
          status: string | null
          uptime: number | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          service_name: string
          status?: string | null
          uptime?: number | null
        }
        Update: {
          created_at?: string | null
          id?: string
          service_name?: string
          status?: string | null
          uptime?: number | null
        }
        Relationships: []
      }
      sp_transactions: {
        Row: {
          amount: number
          created_at: string | null
          description: string | null
          id: string
          reference_id: string | null
          type: string
          user_id: string | null
        }
        Insert: {
          amount: number
          created_at?: string | null
          description?: string | null
          id?: string
          reference_id?: string | null
          type: string
          user_id?: string | null
        }
        Update: {
          amount?: number
          created_at?: string | null
          description?: string | null
          id?: string
          reference_id?: string | null
          type?: string
          user_id?: string | null
        }
        Relationships: []
      }
      support_conversations: {
        Row: {
          created_at: string | null
          id: string
          status: string | null
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          status?: string | null
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          status?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
      support_messages: {
        Row: {
          content: string
          conversation_id: string
          created_at: string | null
          id: string
          sender: string | null
        }
        Insert: {
          content: string
          conversation_id: string
          created_at?: string | null
          id?: string
          sender?: string | null
        }
        Update: {
          content?: string
          conversation_id?: string
          created_at?: string | null
          id?: string
          sender?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "support_messages_conversation_id_fkey"
            columns: ["conversation_id"]
            isOneToOne: false
            referencedRelation: "support_conversations"
            referencedColumns: ["id"]
          },
        ]
      }
      tournament_participants: {
        Row: {
          created_at: string | null
          id: string
          tournament_id: string | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          tournament_id?: string | null
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          tournament_id?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "tournament_participants_tournament_id_fkey"
            columns: ["tournament_id"]
            isOneToOne: false
            referencedRelation: "tournaments"
            referencedColumns: ["id"]
          },
        ]
      }
      tournaments: {
        Row: {
          created_at: string | null
          description: string | null
          id: string
          max_participants: number | null
          sp_prize: number | null
          starts_at: string | null
          status: string | null
          title: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          id?: string
          max_participants?: number | null
          sp_prize?: number | null
          starts_at?: string | null
          status?: string | null
          title: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          id?: string
          max_participants?: number | null
          sp_prize?: number | null
          starts_at?: string | null
          status?: string | null
          title?: string
        }
        Relationships: []
      }
      transactions: {
        Row: {
          buyer_id: string | null
          code: string
          created_at: string | null
          id: string
          listing_id: string | null
          metadata: Json | null
          seller_id: string | null
          status: string | null
          tax_sp: number | null
          total_sp: number | null
          workspace_id: string | null
        }
        Insert: {
          buyer_id?: string | null
          code: string
          created_at?: string | null
          id?: string
          listing_id?: string | null
          metadata?: Json | null
          seller_id?: string | null
          status?: string | null
          tax_sp?: number | null
          total_sp?: number | null
          workspace_id?: string | null
        }
        Update: {
          buyer_id?: string | null
          code?: string
          created_at?: string | null
          id?: string
          listing_id?: string | null
          metadata?: Json | null
          seller_id?: string | null
          status?: string | null
          tax_sp?: number | null
          total_sp?: number | null
          workspace_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "transactions_listing_id_fkey"
            columns: ["listing_id"]
            isOneToOne: false
            referencedRelation: "listings"
            referencedColumns: ["id"]
          },
        ]
      }
      user_achievements: {
        Row: {
          achievement_id: string
          completed: boolean | null
          completed_at: string | null
          id: string
          progress: number | null
          user_id: string
        }
        Insert: {
          achievement_id: string
          completed?: boolean | null
          completed_at?: string | null
          id?: string
          progress?: number | null
          user_id: string
        }
        Update: {
          achievement_id?: string
          completed?: boolean | null
          completed_at?: string | null
          id?: string
          progress?: number | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_achievements_achievement_id_fkey"
            columns: ["achievement_id"]
            isOneToOne: false
            referencedRelation: "achievements"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_achievements_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_achievements_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "public_profiles"
            referencedColumns: ["user_id"]
          },
        ]
      }
      user_badges: {
        Row: {
          badge_id: string
          earned_at: string | null
          id: string
          user_id: string
        }
        Insert: {
          badge_id: string
          earned_at?: string | null
          id?: string
          user_id: string
        }
        Update: {
          badge_id?: string
          earned_at?: string | null
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_badges_badge_id_fkey"
            columns: ["badge_id"]
            isOneToOne: false
            referencedRelation: "badges"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_badges_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_badges_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "public_profiles"
            referencedColumns: ["user_id"]
          },
        ]
      }
      user_roles: {
        Row: {
          created_at: string | null
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: []
      }
      workspace_consultations: {
        Row: {
          consultant_id: string | null
          created_at: string
          description: string
          id: string
          requested_by: string
          required_skills: string[] | null
          sp_offered: number
          status: string
          updated_at: string
          workspace_id: string
        }
        Insert: {
          consultant_id?: string | null
          created_at?: string
          description?: string
          id?: string
          requested_by: string
          required_skills?: string[] | null
          sp_offered?: number
          status?: string
          updated_at?: string
          workspace_id: string
        }
        Update: {
          consultant_id?: string | null
          created_at?: string
          description?: string
          id?: string
          requested_by?: string
          required_skills?: string[] | null
          sp_offered?: number
          status?: string
          updated_at?: string
          workspace_id?: string
        }
        Relationships: []
      }
      workspace_deliverables: {
        Row: {
          approved_at: string | null
          approved_by: string | null
          created_at: string | null
          description: string | null
          file_id: string | null
          id: string
          stage_id: string | null
          status: string | null
          title: string
          workspace_id: string
        }
        Insert: {
          approved_at?: string | null
          approved_by?: string | null
          created_at?: string | null
          description?: string | null
          file_id?: string | null
          id?: string
          stage_id?: string | null
          status?: string | null
          title: string
          workspace_id: string
        }
        Update: {
          approved_at?: string | null
          approved_by?: string | null
          created_at?: string | null
          description?: string | null
          file_id?: string | null
          id?: string
          stage_id?: string | null
          status?: string | null
          title?: string
          workspace_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "workspace_deliverables_file_id_fkey"
            columns: ["file_id"]
            isOneToOne: false
            referencedRelation: "workspace_files"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workspace_deliverables_stage_id_fkey"
            columns: ["stage_id"]
            isOneToOne: false
            referencedRelation: "workspace_stages"
            referencedColumns: ["id"]
          },
        ]
      }
      workspace_files: {
        Row: {
          ai_feedback: string | null
          ai_quality_score: number | null
          created_at: string | null
          file_size: number | null
          file_type: string | null
          file_url: string
          id: string
          name: string
          notes: string | null
          uploaded_by: string
          version: number | null
          workspace_id: string
        }
        Insert: {
          ai_feedback?: string | null
          ai_quality_score?: number | null
          created_at?: string | null
          file_size?: number | null
          file_type?: string | null
          file_url: string
          id?: string
          name: string
          notes?: string | null
          uploaded_by: string
          version?: number | null
          workspace_id: string
        }
        Update: {
          ai_feedback?: string | null
          ai_quality_score?: number | null
          created_at?: string | null
          file_size?: number | null
          file_type?: string | null
          file_url?: string
          id?: string
          name?: string
          notes?: string | null
          uploaded_by?: string
          version?: number | null
          workspace_id?: string
        }
        Relationships: []
      }
      workspace_invites: {
        Row: {
          created_at: string
          created_by: string
          expires_at: string
          id: string
          role: string
          token: string
          used_at: string | null
          used_by: string | null
          workspace_id: string
        }
        Insert: {
          created_at?: string
          created_by: string
          expires_at?: string
          id?: string
          role?: string
          token?: string
          used_at?: string | null
          used_by?: string | null
          workspace_id: string
        }
        Update: {
          created_at?: string
          created_by?: string
          expires_at?: string
          id?: string
          role?: string
          token?: string
          used_at?: string | null
          used_by?: string | null
          workspace_id?: string
        }
        Relationships: []
      }
      workspace_members: {
        Row: {
          id: string
          joined_at: string | null
          role: string | null
          user_id: string
          workspace_id: string
        }
        Insert: {
          id?: string
          joined_at?: string | null
          role?: string | null
          user_id: string
          workspace_id: string
        }
        Update: {
          id?: string
          joined_at?: string | null
          role?: string | null
          user_id?: string
          workspace_id?: string
        }
        Relationships: []
      }
      workspace_messages: {
        Row: {
          content: string
          created_at: string | null
          id: string
          metadata: Json | null
          sender_id: string
          type: string | null
          workspace_id: string
        }
        Insert: {
          content: string
          created_at?: string | null
          id?: string
          metadata?: Json | null
          sender_id: string
          type?: string | null
          workspace_id: string
        }
        Update: {
          content?: string
          created_at?: string | null
          id?: string
          metadata?: Json | null
          sender_id?: string
          type?: string | null
          workspace_id?: string
        }
        Relationships: []
      }
      workspace_stages: {
        Row: {
          created_at: string | null
          description: string | null
          id: string
          name: string
          order_index: number | null
          sp_allocated: number | null
          status: string | null
          updated_at: string | null
          workspace_id: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          id?: string
          name: string
          order_index?: number | null
          sp_allocated?: number | null
          status?: string | null
          updated_at?: string | null
          workspace_id: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          id?: string
          name?: string
          order_index?: number | null
          sp_allocated?: number | null
          status?: string | null
          updated_at?: string | null
          workspace_id?: string
        }
        Relationships: []
      }
      workspaces: {
        Row: {
          created_at: string | null
          created_by: string
          escrow_id: string | null
          id: string
          listing_id: string | null
          status: string | null
          title: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          created_by: string
          escrow_id?: string | null
          id: string
          listing_id?: string | null
          status?: string | null
          title?: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string
          escrow_id?: string | null
          id?: string
          listing_id?: string | null
          status?: string | null
          title?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "workspaces_escrow_id_fkey"
            columns: ["escrow_id"]
            isOneToOne: false
            referencedRelation: "escrow_contracts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workspaces_listing_id_fkey"
            columns: ["listing_id"]
            isOneToOne: false
            referencedRelation: "listings"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      leaderboard_achievements: {
        Row: {
          achievement_description: string | null
          achievement_icon: string | null
          achievement_id: string | null
          achievement_name: string | null
          completed: boolean | null
          completed_at: string | null
          user_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "user_achievements_achievement_id_fkey"
            columns: ["achievement_id"]
            isOneToOne: false
            referencedRelation: "achievements"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_achievements_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_achievements_user_id_profiles_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "public_profiles"
            referencedColumns: ["user_id"]
          },
        ]
      }
      public_profiles: {
        Row: {
          availability: string | null
          avatar_emoji: string | null
          avatar_url: string | null
          badges: Json | null
          bio: string | null
          certificates: Json | null
          created_at: string | null
          display_name: string | null
          elo: number | null
          full_name: string | null
          hourly_rate: string | null
          interests: string[] | null
          location: string | null
          needs: string[] | null
          portfolio_items: Json | null
          response_time: string | null
          skill_levels: Json | null
          skills: string[] | null
          slogan: string | null
          sp: number | null
          streak_days: number | null
          tier: string | null
          total_gigs_completed: number | null
          university: string | null
          user_id: string | null
        }
        Insert: {
          availability?: string | null
          avatar_emoji?: string | null
          avatar_url?: string | null
          badges?: Json | null
          bio?: string | null
          certificates?: Json | null
          created_at?: string | null
          display_name?: string | null
          elo?: number | null
          full_name?: string | null
          hourly_rate?: string | null
          interests?: string[] | null
          location?: string | null
          needs?: string[] | null
          portfolio_items?: Json | null
          response_time?: string | null
          skill_levels?: Json | null
          skills?: string[] | null
          slogan?: string | null
          sp?: number | null
          streak_days?: number | null
          tier?: string | null
          total_gigs_completed?: number | null
          university?: string | null
          user_id?: string | null
        }
        Update: {
          availability?: string | null
          avatar_emoji?: string | null
          avatar_url?: string | null
          badges?: Json | null
          bio?: string | null
          certificates?: Json | null
          created_at?: string | null
          display_name?: string | null
          elo?: number | null
          full_name?: string | null
          hourly_rate?: string | null
          interests?: string[] | null
          location?: string | null
          needs?: string[] | null
          portfolio_items?: Json | null
          response_time?: string | null
          skill_levels?: Json | null
          skills?: string[] | null
          slogan?: string | null
          sp?: number | null
          streak_days?: number | null
          tier?: string | null
          total_gigs_completed?: number | null
          university?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
    }
    Functions: {
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
    }
    Enums: {
      app_role: "admin" | "user" | "moderator" | "enterprise"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["admin", "user", "moderator", "enterprise"],
    },
  },
} as const
