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
    @amazon_config ||= YAML.load_file(Rails.root.join("config", "amazon.yml"))[Rails.env]
  end
end
