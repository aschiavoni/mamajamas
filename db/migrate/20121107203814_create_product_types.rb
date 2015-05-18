class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.integer :category_id
      t.string :name
      t.string :buy_before
      t.integer :priority
      t.timestamps null: false
    end
  end
end
