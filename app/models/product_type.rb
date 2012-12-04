class ProductType < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [ :slugged ]

  attr_accessible :category_id, :name, :when_to_buy, :priority

  belongs_to :category
  belongs_to :when_to_buy_suggestion
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  class << self
    def by_category(category)
      category.blank? ? scoped : where(category_id: category.id)
    end
  end

  # TODO: remove this when we have all product images available
  # temporary accessor for product types without image names
  def image_name
    read_attribute(:image_name) || "unknown.png"
  end

  def when_to_buy
    when_to_buy_suggestion.name
  end

  def when_to_buy=(when_to_buy)
    suggestion = WhenToBuySuggestion.find_by_name(when_to_buy)
    unless suggestion.blank?
      self.when_to_buy_suggestion = suggestion 
    end
  end
end
