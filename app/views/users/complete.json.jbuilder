json.username @profile.user.username
json.email @profile.user.email
json.errors @profile.user.errors if @profile.user.errors.size > 0
json.redirect_path @redirect_path
