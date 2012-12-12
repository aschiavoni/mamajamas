ProductType.all.each do |product_type|
  puts product_type.name
  product_type.queries.each do |query|
    puts "  #{query.query}"
  end
  puts
end
