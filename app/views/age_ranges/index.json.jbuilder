json.array!(@age_ranges) do |age_range|
  json.id age_range.id
  json.name age_range.name
  json.position age_range.position
end
