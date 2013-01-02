class ProductType < ActiveRecord::Base
  include Categorizable
  include WhenToBuyAccessors

  extend FriendlyId
  friendly_id :name, use: [ :slugged ]

  attr_accessible :name, :when_to_buy, :priority

  belongs_to :user
  belongs_to :when_to_buy_suggestion
  has_many :queries, class_name: "ProductTypeQuery", dependent: :destroy
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: true

  scope :global, where(user_id: nil)

  # TODO: remove this when we have all product images available
  # temporary accessor for product types without image names
  def image_name
    read_attribute(:image_name) || "unknown.png"
  end

  def has_query?(query)
    !queries.where(query: query).blank?
  end
end
