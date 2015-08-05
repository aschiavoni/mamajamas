class AddGiftedQuantityToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :gifted_quantity, :integer, null: false, default: 0
  end
end
