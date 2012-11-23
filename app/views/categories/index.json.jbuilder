json.array! @categories do |category|
  json.id category.id
  json.name category.name
  json.slug category.slug
end
