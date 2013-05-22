VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :fakeweb
  c.ignore_localhost = true
end
