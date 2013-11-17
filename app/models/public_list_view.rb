class PublicListView < ListView
  def initialize(list, category_slug = nil, preview = false, current_user = nil)
    super(list, category_slug, current_user)
    @preview = preview
  end

  def preview?
    @preview == true
  end

  def list_entries
    @list_entries ||= list.shared_list_entries(category)
  end

  def categories
    @categories ||= list.shared_list_categories
  end

  def all_categories
    @all_categories ||= Category.all
  end

  def following?
    return false unless current_user
    current_user.following?(owner)
  end

  def public_category_path(slug)
    if preview?
      public_list_preview_category_list_path(slug)
    else
      public_list_category_path(owner.slug, slug)
    end
  end

  def public_all_items_path
    if preview?
      public_list_preview_list_path
    else
      public_list_path(owner.slug)
    end
  end
end
