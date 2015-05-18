class Quiz::Age < Quiz::Question
  def choices
    @choices ||= []
  end

  def rules
    # do nothing
  end
end
