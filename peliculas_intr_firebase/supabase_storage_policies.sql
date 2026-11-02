create policy "Public can view profile photos"
on storage.objects for select
using (bucket_id = 'profile-photos');

create policy "Users can upload their own profile photo"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'profile-photos'
  and (storage.foldername(name))[1] = (select auth.jwt() ->> 'sub')
);

create policy "Users can update their own profile photo"
on storage.objects for update to authenticated
using (
  bucket_id = 'profile-photos'
  and (storage.foldername(name))[1] = (select auth.jwt() ->> 'sub')
)
with check (
  bucket_id = 'profile-photos'
  and (storage.foldername(name))[1] = (select auth.jwt() ->> 'sub')
);
