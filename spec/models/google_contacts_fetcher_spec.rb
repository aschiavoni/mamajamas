describe GoogleContactsFetcher do

  let (:access_token) {
    "ya29.AHES6ZTZy6lCQxUaBAPba67wtXbQkJXy7NMYvMTIlNUYmxasthBJcw"
  }

  it "retrieves google contacts" do
    VCR.use_cassette('google/contacts') do
      auth = create(:authentication,
                    access_token: access_token)
      fetcher = GoogleContactsFetcher.new(auth, GOOGLE_AUTH_CONFIG["app_id"],
                                          GOOGLE_AUTH_CONFIG["secret_key"],
                                          GOOGLE_AUTH_CONFIG["scope"])
      fetcher.contacts.size.should > 0
    end
  end

  it "only includes contacts with a name" do
    VCR.use_cassette('google/contacts') do
      auth = create(:authentication, access_token: access_token)
      fetcher = GoogleContactsFetcher.new(auth,
                                          GOOGLE_AUTH_CONFIG["app_id"],
                                          GOOGLE_AUTH_CONFIG["secret_key"],
                                          GOOGLE_AUTH_CONFIG["scope"])
      fetcher.contacts.map do |c|
        c[:name]
      end.select { |n| n.blank? }.size.should == 0
    end
  end

  it "only includes contacts with an email address" do
    VCR.use_cassette('google/contacts') do
      auth = create(:authentication, access_token: access_token)
      fetcher = GoogleContactsFetcher.new(auth,
                                          GOOGLE_AUTH_CONFIG["app_id"],
                                          GOOGLE_AUTH_CONFIG["secret_key"],
                                          GOOGLE_AUTH_CONFIG["scope"])
      fetcher.contacts.map do |c|
        c[:email]
      end.select { |e| e.blank? }.size.should == 0
    end
  end

end
