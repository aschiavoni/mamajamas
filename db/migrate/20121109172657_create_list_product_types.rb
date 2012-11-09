class CreateListProductTypes < ActiveRecord::Migration
  def change
    create_table :list_product_types do |t|
      t.references :list
      t.references :product_type
      t.references :category
      t.timestamps
    end
    add_index :list_product_types, :list_id
    add_index :list_product_types, :product_type_id
    add_index :list_product_types, :category_id
  end
end
