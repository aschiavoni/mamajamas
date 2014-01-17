avatar_dir = "app/assets/images/avatars/*"
MAMAJAMAS_PROFILE_PICTURE_AVATARS = Dir[avatar_dir].map { |f| File.basename(f) }
