class AddHiddenToRecommendedProduct < ActiveRecord::Migration
  def change
    add_column :recommended_products, :hidden, :boolean, null: false, default: false
  end
end
