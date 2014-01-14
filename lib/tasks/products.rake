namespace :mamajamas do
  namespace :products do
    desc "Search amazon for all active product types"
    task fetch: :environment do
      cache_hours = Rails.env.development? ? 96 : 24
      fetcher = CachedProductFetcher.new cache_hours

      count = ProductType.global_active.count.to_f
      # msg_length = 0
      ProductType.global_active.each_with_index do |product_type, i|
        percent_complete = ((i + 1) / count * 100.0).ceil
        msg = "#{percent_complete}%: Searching for #{product_type.name}..."
        # print "\r#{msg.ljust(msg_length)}"
        # msg_length = msg.length
        puts msg
        fetcher.fetch(product_type, pages: 1)
      end
      # print "\r" + "Done".ljust(msg_length)
      puts "Done"
    end

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

    desc "Clear stale products"
    task remove_stale: :environment do
      stale_count = 0
      expired_count = Product.expired.count
      Product.expired.each_with_index do |product, i|
        percent_complete = ((i + 1) / expired_count * 100.0).ceil
        print "\r#{percent_complete}%  "
        product.destroy
        stale_count += 1
      end
      puts "Removed #{stale_count} expired products."
    end
  end
end
