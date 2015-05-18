# run via rails runner

count = 6
app_id = FACEBOOK_CONFIG["app_id"]
secret = FACEBOOK_CONFIG["secret_key"]

@test_users = Koala::Facebook::TestUsers.new(:app_id => app_id,
                                             :secret => secret)

puts "Creating #{count} users..."
@test_users.create_network(count, true, "email, user_photos, publish_stream")
puts "Done"
