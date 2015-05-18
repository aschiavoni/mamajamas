class Quiz::Sleeping < Quiz::Question
  def choices
    @choices ||= [
      "Bassinet",
      "Crib",
      "Co-Sleeping"
    ]
  end

  def rules
    if excluded("Crib")
      set_priority("Crib", 3)
      set_priority("Crib Sheets", 3)
    end

    if excluded("Bassinet")
      set_priority("Cradle/Bassinet", 3)
      set_priority("Bassinet Sheets", 3)
    end

    if excluded("Bassinet", "Co-Sleeping")
      set_priority("Co-sleeper", 3)
      set_priority("Co-sleeper sheets", 3)
    end

    if included("Bassinet")
      set_priority("Cradle/Bassinet", 1)
      set_priority("Bassinet Sheets", 1)
    end

    if included("Crib")
      set_priority("Crib", 1)
      set_priority("Crib Sheets", 1)
    end
  end
end
