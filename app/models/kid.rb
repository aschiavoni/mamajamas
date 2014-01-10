class Kid < ActiveRecord::Base
  belongs_to :age_range
  belongs_to :user

  attr_accessible :birthday, :gender, :name, :age_range_name
  attr_accessible :due_date, :multiples

  def age_range_name
    return nil if age_range.blank?
    age_range.name
  end

  def age_range_name=(name)
    age = AgeRange.find_by_name(name)
    if age.present?
      self.age_range = age
    end
  end
end
