class AgeRangeCreator
  AGE_RANGES = [
    "Pre-birth",
    "0-3 mo",
    "4-6 mo",
    "7-12 mo",
    "13-18 mo",
    "19-24 mo",
    "2y",
    "3y",
    "4y",
    "5y+"
  ]

  def self.create!
    AGE_RANGES.each_with_index do |age, position|
      age_range = AgeRange.find_by_name(age)
      if age_range.blank?
        AgeRange.create!(name: age, position: position)
      else
        age_range.update_attributes!(position: position)
      end
    end
  end
end
