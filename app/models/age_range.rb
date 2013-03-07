class AgeRange < ActiveRecord::Base
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

  def newborn?
    position = self.position
    position > self.class.pre_birth.position &&
      position <= self.class.zero_to_three_months.position
  end

  def infant?
    position = self.position
    position > self.class.zero_to_three_months.position &&
      position <= self.class.thirteen_to_eighteen_months.position
  end

  def self.pre_birth
    where(name: "Pre-birth").first
  end

  def self.zero_to_three_months
    where(name: "0-3 mo").first
  end

  def self.thirteen_to_eighteen_months
    where(name: "13-18 mo").first
  end

  def self.two_years
    where(name: "2y").first
  end
end
