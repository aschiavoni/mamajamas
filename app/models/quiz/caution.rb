class Quiz::Caution < Quiz::Question
  def choices
    @choices ||= (1..5).to_a.map(&:to_s)
  end

  def rules
    if included('4', '5')
      set_priority('Bath Tub', 1)
      set_priority('Bath Stool or Kneeler', 2)
      set_priority('Faucet Cover', 2)
      set_priority('Bath Thermometer', 2)
      set_priority('Wipes Warmer', 2)
      set_priority('Fetal Doppler', 2)
      set_priority('Outdoor Blanket or Mat', 2)
      set_priority('Shopping Cart Cover', 2)
      set_priority('Baby Monitor', 1)
      set_priority('Car Seat Head Support', 2)
      set_priority('Car Mirror', 2)
      set_priority('Car Sunshade', 2)
      set_priority('Outlet Cover', 1)
      set_priority('Baby Pain Reliever', 1)
      set_priority('Door Lock Cover', 2)
      set_priority('Toilet Lock', 2)
      set_priority('Window Safety Supplies', 2)
      set_priority('Fridge Latch', 2)
    end

    if included('5')
      set_priority('Bath Tub', 1)
      set_priority('Bath Seat', 2)
      set_priority('Bath Mat', 2)
      set_priority('Bath Rail or Handle', 2)
      set_priority('Air Purifier', 2)
      set_priority('Banister Guard', 2)
    end

    if included('1', '2', '3')
      set_priority('Bath Tub', 2)
      set_priority('Bath Stool or Kneeler', 3)
      set_priority('Faucet Cover', 3)
      set_priority('Bath Thermometer', 3)
      set_priority('Wipes Warmer', 3)
      set_priority('Fetal Doppler', 3)
      set_priority('Outdoor Blanket or Mat', 3)
      set_priority('Shopping Cart Cover', 3)
      set_priority('Baby Monitor', 2)
      set_priority('Car Seat Head Support', 3)
      set_priority('Car Mirror', 3)
      set_priority('Car Sunshade', 3)
      set_priority('Outlet Cover', 2)
      set_priority('Baby Pain Reliever', 2)
      set_priority('Door Lock Cover', 3)
      set_priority('Toilet Lock', 3)
      set_priority('Window Safety Supplies', 3)
      set_priority('Fridge Latch', 3)
    end

    if included('1', '2', '3', '4')
      set_priority('Bath Seat', 3)
      set_priority('Bath Mat', 3)
      set_priority('Bath Rail or Handle', 3)
      set_priority('Air Purifier', 3)
      set_priority('Banister Guard', 3)
    end
  end
end

