class IncreaseListItemsNotesSize < ActiveRecord::Migration
  def up
    change_column :list_items, :notes, :text
  end

  def down
    change_column :list_items, :notes, :string
  end
end
