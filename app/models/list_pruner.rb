class ListPruner
  def initialize(list)
    @list = list
  end

  def prune!
    list.list_items.placeholders.each do |list_item|
      list_item.destroy if list_item.priority == 3
    end
  end

  private

  def list
    @list
  end
end
