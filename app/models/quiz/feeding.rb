class Quiz::Feeding < Quiz::Question
  def choices
    @choices ||= [
      "Breast Feed",
      "Bottle Feed",
      "Pump"
    ]
  end

  def rules
    if included("Bottle Feed")
      set_priority("Bottle Brush", 1)
    end

    if included("Bottle Feed", "Pump")
      set_priority("Bottle Warmer", 1)
      set_priority("Bottle Sterilizer", 2)
    end

    if only("Breast Feed")
      set_priority("Bottle Drying Rack", 3)
    end

    if only("Bottle Feed")
      set_priority("Nursing Pads", 3)
      set_priority("Nursing Top", 3)
      set_priority("Nursing Stool", 3)
      set_priority("Nursing Book", 3)
      set_priority("Nursing Tea", 3)
    end

    if excluded("Breast Feed")
      set_priority("Nursing Pillow", 2)
      set_priority("Breast/Nipple Care", 3)
      set_priority("Nursing Cover", 3)
    end

    if excluded("Pump")
      set_priority("Milk Storage", 3)
      set_priority("Breast Pump", 3)
      set_priority("Pumping Bra", 3)
    end

    if excluded("Bottle Feed")
      set_priority("Bottle", 2)
    end
  end
end
