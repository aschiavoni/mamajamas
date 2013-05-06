class ProductFetcherFactory
  class << self
    def create(provider)
      self.new.create(provider)
    end
  end

  def create(provider)
    # get the config options if applicable
    config_options = ProductFetcherConfiguration.for(provider)

    # create the finder instance
    klass_name = "#{provider.to_s.titleize}ProductFetcher"
    klass = Object.const_get(klass_name)
    klass.new(config_options)
  end
end
