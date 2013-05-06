config = ProductFetcherConfiguration.for('amazon')
fetcher = AmazonProductFetcher.new ({
  "associate_tag" => config['associate_tag'],
  "access_key_id" => config['access_key_id'],
  "secret_key" => config['secret_key']
})

puts fetcher.fetch ARGV[0] || "strollers"
