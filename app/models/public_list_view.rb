class PublicListView < ListView
  def initialize(list, category_slug = nil, preview = false, current_user = nil)
    super(list, category_slug, current_user)
    @preview = preview
  end

  def preview?
    @preview == true
  end

  def list_entries
    @list_entries ||= get_list_entries
  end

  def categories
    @categories ||= get_categories
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

  private

  def get_list_entries
    if preview?
      list.public_preview_list_entries(category)
    else
      list.public_list_entries(category)
    end
  end

  def get_categories
    if preview?
      list.public_preview_list_categories
    else
      list.public_list_categories
    end
  end
end
