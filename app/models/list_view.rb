class ListView
  include Rails.application.routes.url_helpers

  attr_reader :list
  attr_reader :category_slug
  attr_reader :current_user

  def initialize(list, category_slug = nil, current_user = nil)
    @list = list
    @category_slug = category_slug
    @current_user = current_user
  end

  def categories
    @categories ||= list.categories.for_list
  end

  def list_entries
    @list_entries ||= list.list_entries(category)
  end

  def category
    @category ||= find_category
  end

  def owner
    @owner ||= decorated_owner
  end

  def default_category?
    @category_slug.blank?
  end

  private

  def find_category
    if @category_slug.present?
      @category = categories.by_slug(@category_slug).first
    end
    @category
  end

  def decorated_owner
    owner = list.user
    owner.class.send(:include, UserDecorator)
    owner
  end
end
