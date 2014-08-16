class CreateProductRatings < ActiveRecord::Migration
  def change
    create_table :product_ratings do |t|
      t.string :vendor
      t.string :vendor_id
      t.float :rating, null: false, default: 0.0

      t.timestamps null: false
    end

    add_index :product_ratings, :vendor_id
    add_index :product_ratings, :vendor
  end
end
