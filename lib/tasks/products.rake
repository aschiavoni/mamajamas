namespace :mamajamas do
  namespace :products do
    desc "Search amazon for product suggestions"
    task suggestions: :environment do
      require_dependency 'product'
      count = ProductType.all.count.to_f
      ProductType.all.each_with_index do |product_type, i|
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

    desc "Clear product fetcher cache"
    task clear_fetcher_cache: :environment do
      REDIS.keys("product:fetcher:*").each do |key|
        REDIS.del(key)
      end
    end

    desc "Clear product searcher cache"
    task clear_searcher_cache: :environment do
      REDIS.keys("product:searcher:*").each do |key|
        REDIS.del(key)
      end
    end

    desc "Clear product suggestions cache"
    task clear_suggestions_cache: :environment do
      REDIS.keys("product:suggestions:*").each do |key|
        REDIS.del(key)
      end
    end
  end
end
