class PublicListView < ListView
  def initialize(list, category_slug = nil, preview = false)
    super(list, category_slug)
    @preview = preview
  end

  def preview?
    @preview == true
  end

  def list_entries
    @list_entries ||= list.public_list_entries(category)
  end
end
