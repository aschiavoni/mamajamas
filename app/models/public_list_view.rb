class PublicListView < ListView
  def list_entries
    @list_entries ||= list.public_list_entries(category)
  end
end
