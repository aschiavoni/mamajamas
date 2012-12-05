json.array!(@suggestions) do |suggestion|
  json.id suggestion.id
  json.name suggestion.name
  json.position suggestion.position
end
