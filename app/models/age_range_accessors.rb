module AgeRangeAccessors
  def age
    age_range.present? ? age_range.name : nil
  end

  def age=(age)
    age_range = AgeRange.find_by_name(age)
    unless age_range.blank?
      self.age_range = age_range
    end
  end
end
