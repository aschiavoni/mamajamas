class AddPriceToRecommendedProduct < ActiveRecord::Migration
  def change
    add_column :recommended_products, :price, :string
  end
end
