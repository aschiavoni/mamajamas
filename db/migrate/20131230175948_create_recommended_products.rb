class CreateRecommendedProducts < ActiveRecord::Migration
  def change
    create_table :recommended_products do |t|
      t.references :product_type
      t.string :name
      t.string :link
      t.string :vendor
      t.string :vendor_id
      t.string :image_url
      t.string :tag

      t.timestamps null: false
    end
    add_index :recommended_products, :product_type_id
  end
end
