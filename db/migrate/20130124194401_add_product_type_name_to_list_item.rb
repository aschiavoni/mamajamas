class AddProductTypeNameToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :product_type_name, :string
  end
end
