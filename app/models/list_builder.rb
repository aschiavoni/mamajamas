class ListBuilder
  attr_reader :list

  def initialize(user, kid = nil, comparer = AgeRangeComparer)
    @user = user
    @kid = kid
    @list = user.list || List.new
    @new_list = @list.new_record?
    @comparer = comparer.new
  end

  def build!(product_types = ProductType.global_active)
    return if list.built_at.present?
    user.list = list
    list.save! if list.id.blank?

    if product_types.respond_to?(:includes)
      product_types = product_types.includes(:age_range).includes(:category)
    end

    List.transaction do
      product_types.each do |product_type|
        add_placeholder(product_type)
      end
    end

    list.built_at = Time.now.utc
    list.save!
    list
  end

  def add_placeholder(product_type)
    if applicable?(product_type)
      if new_list? || !list.has_placeholder?(product_type)
        List.connection.execute(placeholder_insert(product_type))
      end
    end
  end

  def applicable?(product_type)
    return true unless kid.present?
    product_type_applicable?(product_type) && category_applicable?(product_type)
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

  def new_list?
    @new_list
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

  # POSTGRESQL SPECIFIC, MIGHT NEED UPDATING IF Model(s) changes
  # But this is super fast
  def placeholder_insert(pt, ts = Time.now.utc)
    %Q(INSERT INTO "list_items"
    ("age_range_id", "category_id", "created_at", "image_url", "list_id",
    "placeholder", "priority", "product_type_id", "product_type_name",
    "quantity", "updated_at")
    VALUES (
    #{pt.age_range_id},
    #{pt.category_id},
    '#{ts}',
    '#{pt.image_name}',
    #{list.id},
    TRUE,
    #{pt.priority},
    #{pt.id},
    '#{pt.name}',
    #{pt.recommended_quantity},
    '#{ts}'
    )
    )
  end
end
