namespace :mamajamas do
  namespace :products do
    desc "Search amazon for all active product types"
    task search: :environment do
      searcher = CachedProductSearcher.new

      ProductType.all.each_with_index do |product_type, i|
        puts "Searching for #{product_type.name}..."
        searcher.search(product_type)
      end
    end

    desc "Clear product search cache"
    task clear_cache: :environment do
      REDIS.keys("product:searcher:*").each do |key|
        REDIS.del(key)
      end
    end
  end
end
