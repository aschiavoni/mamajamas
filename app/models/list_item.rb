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

  validates :name, :link, presence: true, unless: :placeholder?
  validates :product_type_name, presence: true
  validates :notes, length: { maximum: 1000 }
  validates :category_id, presence: true

  scope :placeholders, where(placeholder: true)
  scope :user_items, where(placeholder: false)
  scope :shared_items, where(placeholder: false, shared: true)
  scope :vendored_items, where("vendor IS NOT NULL")

  def self.unique_products
    vendored_items.select("DISTINCT vendor_id, vendor").map do |list_item|
      [ list_item.vendor_id, list_item.vendor ]
    end
  end
end
