class ProductType < ActiveRecord::Base
  include Categorizable
  include AgeRangeAccessors

  extend FriendlyId
  friendly_id :name, use: [ :slugged ]

  attr_accessible :name, :plural_name, :age_range_id, :priority
  attr_accessible :image_name, :search_index, :search_query
  attr_accessible :recommended_quantity

  belongs_to :user
  belongs_to :age_range
  has_many :queries, class_name: "ProductTypeQuery", dependent: :destroy
  has_many :list_items
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :plural_name, presence: true
  validates :image_name, presence: true
  validates :recommended_quantity,
    numericality: { only_integer: true, greater_than: 0 }

  scope :global, where(user_id: nil)
  scope :user, where("user_id IS NOT NULL")

  before_save do
    self.image_name.downcase!
  end

  # TODO: remove this when we have all product images available
  # temporary accessor for product types without image names
  def image_name
    read_attribute(:image_name) || "unknown.png"
  end

  def has_query?(query)
    !queries.where(query: query).blank?
  end

  def add_query(query)
    queries.create!(query: query) unless has_query?(query)
  end

  def available_products
    available_products = products.active
    if available_products.size == 0
      available_products = Product.active
    end
    available_products
  end

  def admin_deleteable?
    user == nil && list_items.count == 0 && products.count == 0
  end
end
