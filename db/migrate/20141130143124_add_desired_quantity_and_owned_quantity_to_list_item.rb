class AddDesiredQuantityAndOwnedQuantityToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :desired_quantity, :integer, null: false, default: 0
    add_column :list_items, :owned_quantity, :integer, null: false, default: 0
  end
end
