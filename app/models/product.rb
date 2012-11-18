class Product
  include ActiveModel::Serialization

  attr_accessor :name, :link, :id, :rating

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
