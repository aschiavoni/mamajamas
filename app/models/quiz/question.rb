class Quiz::Question
  def self.by_name(name, list)
    Quiz.const_get(name.titleize).new(list)
  end

  def initialize(list, answer_logger = Quiz::Answer)
    @list = list
    @answers = []
    @answer_logger = answer_logger
  end

  def choices
    raise NotImplementedError
  end

  def rules
    raise NotImplementedError
  end

  def answer(*answers)
    answers.each do |answer|
      raise ArgumentError unless choices.include?(answer)
    end
    @answers = answers
    answer_logger.save_answer!(list.user, question_name, answers)
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

  def question_name
    self.class.name.split('::')[1].downcase
  end

  def answer_logger
    @answer_logger
  end
end
