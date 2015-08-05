class AddProductsTables < ActiveRecord::Migration
  create_table :products, :force => true do |t|
    t.references :product_type
    t.string     :name
    t.integer    :rating
    t.integer    :rating_count,           :default => 0, :null => false
    t.string     :url
    t.string     :image_url
    t.string     :medium_image_url
    t.string     :large_image_url
    t.string     :vendor
    t.string     :vendor_id
    t.integer    :sales_rank
    t.string     :brand
    t.string     :manufacturer
    t.string     :model
    t.string     :department
    t.string     :categories
    t.string     :price
    t.text       :description
    t.string     :short_description
    t.string     :product_type_name
    t.float      :mamajamas_rating
    t.integer    :mamajamas_rating_count, :default => 0, :null => false

    t.timestamps null: false
  end
end
