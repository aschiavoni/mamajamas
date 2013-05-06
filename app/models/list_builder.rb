class ListBuilder
  attr_reader :list

  def initialize(user, kid = nil)
    @user = user
    @kid = kid
    @list = List.new
  end

  def build!(product_types = ProductType.global)
    user.list = list

    product_types.each do |product_type|
      add_placeholder(product_type)
    end

    list.save!
    list
  end

  def add_placeholder(product_type)
    if applicable?(product_type)
      list.add_list_item_placeholder(product_type)
    end
  end

  def applicable?(product_type)
    return true unless kid.present?
      product_type_applicable?(product_type) &&
      category_applicable?(product_type)
  end

  def product_type_applicable?(product_type)
    if kid.age_range.newborn?
      return !older_than_thirteen_to_eighteen_months.include?(product_type.age_range)
    elsif kid.age_range.infant?
      return !older_than_two_years.include?(product_type.age_range)
    end
    return true
  end

  def category_applicable?(product_type)
    !(product_type.category == potty_training_category &&
      kid.age_range.position <= AgeRange.thirteen_to_eighteen_months.position)
  end

  private

  def user
    @user
  end

  def kid
    @kid
  end

  def younger_ages
    @younger ||= kid.age_range.younger
  end

  def older_than_thirteen_to_eighteen_months
    @older_than_thirteen ||= AgeRange.thirteen_to_eighteen_months.older
  end

  def older_than_two_years
    @older_than_two_years ||= AgeRange.two_years.older
  end

  def potty_training_category
    @potty_training ||= Category.find("potty-training")
  end
end
