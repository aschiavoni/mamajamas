class RemoveProductTypeIdFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :product_type_id
  end

  def down
    add_column :products, :product_type_id, :integer
  end
end
