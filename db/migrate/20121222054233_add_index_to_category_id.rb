class AddIndexToCategoryId < ActiveRecord::Migration
  def change
    add_index :list_items, :category_id
    add_index :product_types, :category_id
  end
end
