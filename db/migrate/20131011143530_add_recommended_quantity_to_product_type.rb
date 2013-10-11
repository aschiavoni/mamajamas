class AddRecommendedQuantityToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :recommended_quantity, :integer, null: false, default: 1
  end
end
