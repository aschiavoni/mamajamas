class AgeRange < ActiveRecord::Base
  acts_as_list top_of_list: 0

  attr_accessible :name, :position

  validates :position, presence: true
  validates :name, presence: true, uniqueness: true

  def self.find_by_normalized_name!(name)
    age_range = where("lower(name) = ?", name.downcase).first
    raise ActiveRecord::RecordNotFound if age_range.blank?
    age_range
  end
end
