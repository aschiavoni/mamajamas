uri = URI.parse(ENV["REDISTOGO_URL"] || ENV["REDIS_PORT"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
