module WhenToBuyAccessors
  def when_to_buy
    when_to_buy_suggestion.name
  end

  def when_to_buy=(when_to_buy)
    suggestion = WhenToBuySuggestion.find_by_name(when_to_buy)
    unless suggestion.blank?
      self.when_to_buy_suggestion = suggestion 
    end
  end
end
