dropbox_path = "~/Dropbox/Mamajamas/Icons/Icon\\ Artwork/optimized"
icon_path = "app/assets/images/products/icons"

# copy all the files from the dropbox directory structure
cmd = "find #{dropbox_path} -iname \"*.png\" -exec cp {} #{icon_path} \\;"
system cmd

# rename all files to lowercase
Dir.glob("#{icon_path}/*").each do |f|
  File.rename(f, f.downcase)
end
