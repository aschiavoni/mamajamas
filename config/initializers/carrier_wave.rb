if Rails.env.test? || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  amazon_config = YAML.load_file(Rails.root.join("config", "amazon.yml"))[Rails.env]
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider => 'AWS',
      :aws_access_key_id => amazon_config["access_key_id"],
      :aws_secret_access_key => amazon_config["secret_key"]
    }
    config.fog_directory = amazon_config["bucket"]
  end
end
