if resource.present?
  json.username resource.username
  json.email resource.email
  json.errors resource.errors if resource.errors.size > 0
end
json.redirect_path @redirect_path
