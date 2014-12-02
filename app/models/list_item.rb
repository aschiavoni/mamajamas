class ListItem < ActiveRecord::Base
  include Categorizable
  include AgeRangeAccessors

  belongs_to :list, touch: true
  belongs_to :product_type
  belongs_to :age_range
  has_one :list_item_image

  attr_accessible :link, :name, :notes, :owned
  attr_accessible :priority, :rating, :age, :image_url
  attr_accessible :desired_quantity, :owned_quantity, :gifted_quantity
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
  validates(:desired_quantity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 })
  validates(:owned_quantity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 })
  validates(:gifted_quantity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 })

  scope :placeholders, -> { where(placeholder: true) }
  scope :user_items, -> { where(placeholder: false) }
  scope :vendored_items, -> { where.not(vendor: nil) }
  scope :added_since, ->(time) { user_items.where("created_at > ?", time) }
  scope :recommended, -> { where(recommended: true) }
  scope :not_recommended, -> { where.not(recommended: true) }

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

  def price=(new_price)
    if new_price.present?
      p = new_price.dup
      # treat $.0.00 as nil
      if p.gsub(/[^0-9]/i, '').chars.map(&:to_i).uniq.all? { |c| c == 0 }
        p = nil
      end
    else
      p = nil
    end
    write_attribute(:price, p)
  end

  def gift_item(gift_attributes)
    ActiveRecord::Base.transaction do
      gift = Gift.new(gift_attributes.merge(list_item_id: self.id))
      if gift.purchased?
        self.desired_quantity = [ self.desired_quantity - gift.quantity, 0 ].max
        self.owned_quantity = self.owned_quantity + gift.quantity
      end
      gift.save!
      self.save!
      gift
    end
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
