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
  end
end