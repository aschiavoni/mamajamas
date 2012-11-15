class AddProductTypeAndCategoryToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :product_type_id, :integer
    add_column :list_items, :category_id, :integer
  end
end
