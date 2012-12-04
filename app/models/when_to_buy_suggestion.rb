class WhenToBuySuggestion < ActiveRecord::Base
  acts_as_list

  attr_accessible :name, :position

  validates :position, presence: true
  validates :name, presence: true, uniqueness: true
end
