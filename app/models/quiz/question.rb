class Quiz::Question
  def self.by_name(name, list)
    Quiz.const_get(name.titleize).new(list)
  end

  def initialize(list)
    @list = list
    @answers = []
  end

  def choices
    raise NotImplementedError
  end

  def rules
    raise NotImplementedError
  end

  def process_answers!(*answers)
    answers.each do |answer|
      raise ArgumentError unless choices.include?(answer)
    end
    @answers = answers
    rules
  end

  protected

  def set_priority(name, priority)
    list.list_items.where(product_type_name: name).each do |item|
      item.update_attributes!(priority: priority)
    end
  end

  def included(*items)
    items.each do |item|
      return true if answers.include?(item)
    end
    return false
  end

  def excluded(*items)
    items.each do |item|
      return false if answers.include?(item)
    end
    return true
  end

  def only(item)
    answers == [ item ]
  end

  private

  def answers
    @answers
  end

  def list
    @list
  end
end
