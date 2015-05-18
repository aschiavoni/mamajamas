class ProductFetcherConfiguration
  class << self
    def for(provider)
      self.new.configuration_for(provider)
    end
  end

  def configuration_for(provider)
    method_name = "#{provider}_config".to_sym
    self.send(method_name)
  end

  def method_missing(method, *args, &block)
    if method.to_s =~ /.+_config$/
      {}
    else
      super
    end
  end

  private

  def amazon_config
    @amazon_config ||= {
      "associate_tag" => ENV['AMAZON_ASSOCIATE_TAG'],
      "access_key_id" => ENV['AWS_ACCESS_KEY_ID'],
      "secret_key" => ENV['AWS_SECRET_ACCESS_KEY'],
      "bucket" => ENV['FOG_DIRECTORY']
    }
  end
end
