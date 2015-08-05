namespace :mamajamas do
  namespace :products do
    desc "Search amazon for product suggestions"
    task suggestions: :environment do
      require_dependency 'product'
      count = ProductType.global_active.count.to_f
      ProductType.global_active.each_with_index do |product_type, i|
        percent_complete = ((i + 1) / count * 100.0).ceil
        msg = "#{percent_complete}%: Getting suggestions for #{product_type.name}..."
        puts msg
        CachedProductTypeSuggestions.find(product_type)
      end
      puts "Done"
    end

    desc "Calculate average ratings for all products"
    task calculate_ratings: :environment do
      ProductRatingUpdater.new.update
    end
  end
end
