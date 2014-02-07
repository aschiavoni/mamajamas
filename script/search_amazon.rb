config = ProductFetcherConfiguration.for('amazon')
fetcher = AmazonProductFetcher.new(ProductFetcherLogger, {
  "associate_tag" => config['associate_tag'],
  "access_key_id" => config['access_key_id'],
  "secret_key" => config['secret_key']
})

results = fetcher.fetch ARGV[0] || "Baby Shampoo"
puts results.inspect
puts results.size
