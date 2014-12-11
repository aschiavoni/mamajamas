class RemoveOwnedFromListItem < ActiveRecord::Migration
  def change
    remove_column :list_items, :owned, :boolean
  end
end
