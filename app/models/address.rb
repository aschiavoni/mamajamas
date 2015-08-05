class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :country_code, presence: true, length: { is: 2 }
  validates :street, :city, :region, :postal_code, presence: true

  def full_address
    a = street
    a += "\n#{street2}" if street2.present?
    a += "\n#{city}, #{region} #{postal_code}"
    a
  end
end
