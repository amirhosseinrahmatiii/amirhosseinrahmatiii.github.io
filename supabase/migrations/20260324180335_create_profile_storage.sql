/*
  # Create profile storage bucket

  This migration sets up:
  1. A new storage bucket named 'profile' for user profile photos
  2. Public access policies for the profile photos

  The bucket is configured to allow:
  - Public read access to all profile photos
  - Upsert operations for profile updates
*/

DO $$
BEGIN
  -- Create storage bucket if it doesn't exist
  INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
  VALUES (
    'profile',
    'profile',
    true,
    5242880,
    ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp']
  )
  ON CONFLICT (id) DO NOTHING;
END $$;

CREATE POLICY "Profile photos are publicly accessible"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'profile');

CREATE POLICY "Anyone can upload to profile bucket"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'profile');

CREATE POLICY "Anyone can update profile photos"
  ON storage.objects FOR UPDATE
  WITH CHECK (bucket_id = 'profile');