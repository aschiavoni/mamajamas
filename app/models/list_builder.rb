class ListBuilder
  attr_reader :list

  def initialize(user, kid = nil, comparer = AgeRangeComparer)
    @user = user
    @kid = kid
    @list = user.list || List.new
    @comparer = comparer.new
  end

  def build!(product_types = ProductType.global)
    user.list = list

    if product_types.respond_to?(:includes)
      product_types = product_types.includes(:age_range).includes(:category)
    end
    product_types.each do |product_type|
      add_placeholder(product_type)
    end

    list.save!
    list
  end

  def add_placeholder(product_type)
    if applicable?(product_type)
      unless list.has_placeholder?(product_type)
        list.add_list_item_placeholder(product_type)
      end
    end
  end

  def applicable?(product_type)
    return true unless kid.present?
      product_type_applicable?(product_type) &&
      category_applicable?(product_type)
  end

  def product_type_applicable?(product_type)
    if comparer.newborn?(kid.age_range)
      return !older_than_thirteen_to_eighteen_months.include?(product_type.age_range)
    elsif comparer.infant?(kid.age_range)
      return !older_than_two_years.include?(product_type.age_range)
    end
    return true
  end

  def category_applicable?(product_type)
    !(product_type.category == potty_training_category &&
      kid.age_range.position <= comparer.thirteen_to_eighteen_months.position)
  end

  private

  def user
    @user
  end

  def kid
    @kid
  end

  def comparer
    @comparer
  end

  def younger_ages
    @younger ||= kid.age_range.younger
  end

  def older_than_thirteen_to_eighteen_months
    @older_than_thirteen ||= comparer.older(comparer.thirteen_to_eighteen_months)
  end

  def older_than_two_years
    @older_than_two_years ||= comparer.older(comparer.two_years)
  end

  def potty_training_category
    @potty_training ||= Category.find("potty-training")
  end
end
