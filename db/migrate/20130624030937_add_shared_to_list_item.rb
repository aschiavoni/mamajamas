class AddSharedToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :shared, :boolean, default: false, null: false
  end
end
