module ListsHelper
  def completed_list?
    @list.present? && @list.completed?
  end
end
