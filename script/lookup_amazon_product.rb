identifier = ARGV[0] || '0062235893'

config = ProductFetcherConfiguration.for('amazon')

puts config
Amazon::Ecs.options = {
  associate_tag: config["associate_tag"],
  AWS_access_key_id: config["access_key_id"],
  AWS_secret_key: config["secret_key"]
}

puts Amazon::Ecs.item_lookup(identifier, {
  :response_group => 'Large',
}).items
