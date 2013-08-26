class AgeRangeComparer
  def initialize(age_ranges = AgeRange)
    @age_ranges = age_ranges
  end

  def younger(age_range)
    age_ranges.where("position < ?", age_range.position)
  end

  def older(age_range)
    age_ranges.where("position > ?", age_range.position)
  end

  def newborn?(age_range)
    position = age_range.position
    position > pre_birth.position &&
      position <= zero_to_three_months.position
  end

  def infant?(age_range)
    position = age_range.position
    position > zero_to_three_months.position &&
      position <= thirteen_to_eighteen_months.position
  end

  def pre_birth
    age_ranges.where(name: "Pre-birth").first
  end

  def zero_to_three_months
    age_ranges.where(name: "0-3 mo").first
  end

  def four_to_six_months
    age_ranges.where(name: "4-6 mo").first
  end

  def seven_to_twelve_months
    age_ranges.where(name: "7-12 mo").first
  end

  def thirteen_to_eighteen_months
    age_ranges.where(name: "13-18 mo").first
  end

  def two_years
    age_ranges.where(name: "2y").first
  end

  def three_years
    age_ranges.where(name: "3y").first
  end

  def four_years
    age_ranges.where(name: "4y").first
  end

  private

  def age_ranges
    @age_ranges
  end
end
