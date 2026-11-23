insert into storage.buckets (id, name, public)
values ('profile-photos', 'profile-photos', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view profile photos" on storage.objects;
create policy "Public can view profile photos"
on storage.objects for select
using (bucket_id = 'profile-photos');

drop policy if exists "Users can upload their own profile photo" on storage.objects;
create policy "Users can upload their own profile photo"
on storage.objects for insert to public
with check (
  bucket_id = 'profile-photos'
  and (storage.foldername(name))[1] = (select auth.jwt() ->> 'sub')
  and (select auth.jwt() ->> 'iss') = 'https://securetoken.google.com/peliculasintr'
  and (select auth.jwt() ->> 'aud') = 'peliculasintr'
);

drop policy if exists "Users can update their own profile photo" on storage.objects;
create policy "Users can update their own profile photo"
on storage.objects for update to public
using (
  bucket_id = 'profile-photos'
  and (storage.foldername(name))[1] = (select auth.jwt() ->> 'sub')
  and (select auth.jwt() ->> 'iss') = 'https://securetoken.google.com/peliculasintr'
  and (select auth.jwt() ->> 'aud') = 'peliculasintr'
)
with check (
  bucket_id = 'profile-photos'
  and (storage.foldername(name))[1] = (select auth.jwt() ->> 'sub')
  and (select auth.jwt() ->> 'iss') = 'https://securetoken.google.com/peliculasintr'
  and (select auth.jwt() ->> 'aud') = 'peliculasintr'
);
