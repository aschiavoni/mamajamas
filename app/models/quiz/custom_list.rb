class Quiz::CustomList < Quiz::Question
  def choices
    @choices ||= [
      "false",
      "true"
    ]
  end

  def rules
    # do nothing
  end
end
