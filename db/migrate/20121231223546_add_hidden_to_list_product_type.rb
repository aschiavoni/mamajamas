class AddHiddenToListProductType < ActiveRecord::Migration
  def change
    add_column :list_product_types, :hidden, :boolean, default: false
  end
end
