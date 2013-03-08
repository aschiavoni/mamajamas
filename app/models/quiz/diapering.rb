class Quiz::Diapering < Quiz::Question
  def choices
    @choices ||= [
      "Cloth",
      "Disposables"
    ]
  end

  def rules
    if excluded("Disposables")
      set_priority("Disposable Diapers", 3)
    end

    if excluded("Cloth")
      set_priority("Cloth Diapers", 3)
    end

    if included("Cloth")
      set_priority("Cloth Diapers", 1)
      set_priority("Wet Bag", 2)
    end
  end
end
