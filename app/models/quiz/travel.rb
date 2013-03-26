class Quiz::Travel < Quiz::Question
  def choices
    @choices ||= (1..5).to_a.map(&:to_s)
  end

  def rules
    if included('4', '5')
      set_priority('Back Pack', 2)
      set_priority('Portable Crib', 2)
      set_priority('Luggage', 2)
      set_priority('Travel Crib', 2)
      set_priority('Travel Booster Seat', 2)
      set_priority('Travel Game', 2)
      set_priority('Car Seat Bag', 2)
    end

    if included('1', '2', '3')
      set_priority('Back Pack', 3)
      set_priority('Portable Crib', 3)
      set_priority('Luggage', 3)
      set_priority('Travel Crib', 3)
      set_priority('Travel Booster Seat', 3)
      set_priority('Travel Game', 3)
      set_priority('Car Seat Bag', 3)
    end
  end
end

