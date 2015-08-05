class RemoveProductTables < ActiveRecord::Migration
  def up
    drop_table :product_types_products
    drop_table :products
  end

  def down
    create_table "product_types_products", :force => true do |t|
      t.integer "product_type_id"
      t.integer "product_id"
    end

    create_table "products", :force => true do |t|
      t.string   "vendor_id"
      t.string   "vendor"
      t.string   "name"
      t.string   "url"
      t.integer  "rating"
      t.datetime "created_at",                            :null => false
      t.datetime "updated_at",                            :null => false
      t.string   "image_url"
      t.integer  "sales_rank"
      t.string   "brand"
      t.string   "manufacturer"
      t.string   "model"
      t.string   "department"
      t.string   "categories"
      t.string   "price"
      t.string   "medium_image_url"
      t.string   "large_image_url"
      t.float    "mamajamas_rating"
      t.integer  "rating_count",           :default => 0, :null => false
      t.integer  "mamajamas_rating_count", :default => 0, :null => false
    end
  end
end
