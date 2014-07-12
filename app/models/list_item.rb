class ListItem < ActiveRecord::Base
  include Categorizable
  include AgeRangeAccessors

  belongs_to :list, touch: true
  belongs_to :product_type
  belongs_to :age_range
  has_one :list_item_image

  attr_accessible :link, :name, :notes, :owned
  attr_accessible :priority, :rating, :age, :image_url, :quantity
  attr_accessible :category_id, :product_type_id, :product_type_name
  attr_accessible :placeholder, :list_item_image_id
  attr_accessible :vendor, :vendor_id
  attr_accessible :age_range_id
  attr_accessible :recommended
  attr_accessible :price

  validates :name, :link, presence: true, unless: :placeholder?
  validates :product_type_name, presence: true
  validates :notes, length: { maximum: 1000 }
  validates :category_id, presence: true
  validates :age_range_id, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  scope :placeholders, where(placeholder: true)
  scope :user_items, where(placeholder: false)
  scope :vendored_items, where("vendor IS NOT NULL")
  scope :added_since, ->(time) { user_items.where("created_at > ?", time) }
  scope :recommended, where(recommended: true)

  def self.unique_products
    vendored_items.select("DISTINCT vendor_id, vendor").map do |list_item|
      [ list_item.vendor_id, list_item.vendor ]
    end
  end

  def image_url
    u = read_attribute(:image_url)
    u = base_image_url if u.blank?
    u
  end

  private

  def base_image_url
    product_type = self.product_type
    if product_type.present? && product_type.image_name.present?
      product_type.image_name
    else
      "products/icons/unknown.png"
    end
  end
end
