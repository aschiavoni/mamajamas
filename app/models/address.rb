class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :country_code, presence: true, length: { is: 2 }
  validates :street, :city, :region, :postal_code, presence: true
end
