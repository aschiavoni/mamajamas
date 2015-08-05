module BookmarkletHelper
  def selected_category
    if @list_item.category_id.present?
      @categories.select { |c| c[:id] == @list_item.category_id }.first
    else
      @categories.first
    end
  end
end
