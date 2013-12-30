class CreateRecommendedProducts < ActiveRecord::Migration
  def change
    create_table :recommended_products do |t|
      t.references :product_type
      t.string :link
      t.string :vendor
      t.string :vendor_id
      t.string :image_url
      t.string :tag

      t.timestamps
    end
    add_index :recommended_products, :product_type_id
  end
end
