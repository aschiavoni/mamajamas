VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.ignore_localhost = true
  c.ignore_request do |req|
    req.uri == "https://graph.facebook.com/99999/picture?type=large" ||
      URI(req.uri).hostname == "fbstatic-a.akamaihd.net"
  end
end
