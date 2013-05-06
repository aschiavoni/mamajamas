config = ProductSearcherConfiguration.for('amazon')
searcher = AmazonProductSearcher.new ({
  "associate_tag" => config['associate_tag'],
  "access_key_id" => config['access_key_id'],
  "secret_key" => config['secret_key']
})

puts searcher.search ARGV[0] || "strollers"
