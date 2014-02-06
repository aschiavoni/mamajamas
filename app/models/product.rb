class Product
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name
  attr_accessor :rating
  attr_accessor :rating_count
  attr_accessor :url
  attr_accessor :image_url
  attr_accessor :medium_image_url
  attr_accessor :large_image_url
  attr_accessor :vendor
  attr_accessor :vendor_id
  attr_accessor :sales_rank
  attr_accessor :brand
  attr_accessor :manufacturer
  attr_accessor :model
  attr_accessor :department
  attr_accessor :categories
  attr_accessor :price
  attr_accessor :mamajamas_rating
  attr_accessor :mamajamas_rating_count

  validates :name, :vendor, :url, presence: true
  validates :vendor_id, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  def attributes
    {
      name: name,
      rating: rating,
      rating_count: rating_count,
      url: url,
      image_url: image_url,
      medium_image_url: medium_image_url,
      large_image_url: large_image_url,
      vendor: vendor,
      vendor_id: vendor_id,
      sales_rank: sales_rank,
      brand: brand,
      manufacturer: manufacturer,
      model: model,
      department: department,
      categories: categories,
      price: price,
      mamajamas_rating: mamajamas_rating,
      mamajamas_rating_count: mamajamas_rating_count
    }
  end

  def persisted?
    false
  end
end
