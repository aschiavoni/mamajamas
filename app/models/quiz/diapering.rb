class Quiz::Diapering < Quiz::Question
  def choices
    @choices ||= [
      "Cloth Diapers",
      "Disposable Diapers"
    ]
  end

  def rules
    if excluded("Disposable Diapers")
      set_priority("Disposable Diapers", 3)
    end

    if excluded("Cloth Diapers")
      set_priority("Cloth Diapers", 3)
    end

    if included("Cloth Diapers")
      set_priority("Cloth Diapers", 1)
      set_priority("Wet Bag", 2)
    end
  end
end
