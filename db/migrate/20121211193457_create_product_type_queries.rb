class CreateProductTypeQueries < ActiveRecord::Migration
  def change
    create_table :product_type_queries do |t|
      t.references :product_type
      t.string :query
      t.timestamps
    end
    add_index :product_type_queries, :product_type_id
  end
end
