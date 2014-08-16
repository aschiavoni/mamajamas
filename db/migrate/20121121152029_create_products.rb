class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :vendor_id
      t.string :vendor
      t.string :name
      t.references :product_type
      t.string :url
      t.integer :rating

      t.timestamps null: false
    end
    add_index :products, :product_type_id
  end
end
