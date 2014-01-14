class AddActiveToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :active, :boolean, null: false, default: true
  end
end
