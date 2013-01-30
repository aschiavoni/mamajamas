json.(@profile, :username, :first_name, :last_name, :birthday, :list_title)
json.profile_picture do
  json.name @profile.profile_picture.filename
  json.url @profile.profile_picture.url
  json.size @profile.profile_picture.size
end
