class AddPlaceholderToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :placeholder, :boolean, null: false, default: false
  end
end
