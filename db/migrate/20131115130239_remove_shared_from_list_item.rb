class RemoveSharedFromListItem < ActiveRecord::Migration
  def up
    remove_column :list_items, :shared
  end

  def down
    add_column :list_items, :shared, :boolean, default: false, null: false
  end
end
