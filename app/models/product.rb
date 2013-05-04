class Product < ActiveRecord::Base
  has_and_belongs_to_many :product_types

  attr_accessible :name
  attr_accessible :rating
  attr_accessible :url
  attr_accessible :image_url
  attr_accessible :vendor
  attr_accessible :vendor_id
  attr_accessible :sales_rank
  attr_accessible :brand
  attr_accessible :manufacturer
  attr_accessible :model
  attr_accessible :department
  attr_accessible :categories

  validates :name, :vendor, :url, presence: true
  validates :vendor_id, presence: true, uniqueness: { scope: :vendor }

  scope :active, lambda { where("updated_at > ?", (Time.zone.now - 24.hours)) }
  scope :expired, lambda { where("updated_at < ?", (Time.zone.now - 24.hours)) }

  include PgSearch
  pg_search_scope :search,
    against: [ :name, :categories, :brand, :manufacturer, :model, :department ],
    using: { tsearch: { prefix: true, dictionary: 'english' } },
    ignoring: :accents

  def self.text_search(query)
    query.present? ? search(query) : scoped
  end
end
