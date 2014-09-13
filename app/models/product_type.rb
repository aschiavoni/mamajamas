class ProductType < ActiveRecord::Base
  include Categorizable
  include AgeRangeAccessors

  extend FriendlyId
  friendly_id :name, use: [ :slugged, :finders ]

  attr_accessible :name, :plural_name, :age_range_id, :priority
  attr_accessible :image_name, :search_index, :search_query
  attr_accessible :recommended_quantity, :active
  attr_accessible :alias_list

  belongs_to :user
  belongs_to :age_range
  has_many :list_items
  has_many :recommended_products

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :plural_name, presence: true
  validates :image_name, presence: true
  validates :recommended_quantity,
    numericality: { only_integer: true, greater_than: 0 }

  scope :global, -> { where(user_id: nil) }
  scope :global_active, -> { global.where(active: true) }
  scope :user, -> { where("user_id IS NOT NULL") }

  before_save do
    self.image_name.downcase!
  end

  def image_name
    read_attribute(:image_name) || "products/icons/unknown.png"
  end

  def admin_deleteable?
    user == nil && list_items.count == 0
  end

  def alias_list
    (self.aliases || []).join(', ')
  end

  def alias_list=(val)
    new_aliases = []
    if val.present?
      new_aliases = Set.new(val.split(/,\s*/).map(&:strip))
    end
    self.aliases = new_aliases.to_a
  end
end
