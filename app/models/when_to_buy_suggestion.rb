class WhenToBuySuggestion < ActiveRecord::Base
  acts_as_list

  attr_accessible :name, :position

  validates :position, presence: true
  validates :name, presence: true, uniqueness: true

  def younger
    self.class.where("position < ?", position)
  end

  def older
    self.class.where("position > ?", position)
  end
end
