identifier = ARGV[0] || '0062235893,B000056OV0'

config = ProductFetcherConfiguration.for('amazon')
fetcher = AmazonProductFetcher.new(ProductFetcherLogger, {
  "associate_tag" => config['associate_tag'],
  "access_key_id" => config['access_key_id'],
  "secret_key" => config['secret_key']
})

results = fetcher.lookup identifier.split(",")
puts results.inspect
puts results.size
