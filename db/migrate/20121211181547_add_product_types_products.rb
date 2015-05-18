class AddProductTypesProducts < ActiveRecord::Migration
  def change
    create_table :product_types_products do |t|
      t.integer :product_type_id
      t.integer :product_id
    end
  end
end
