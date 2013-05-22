VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :fakeweb
  c.ignore_localhost = true
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
