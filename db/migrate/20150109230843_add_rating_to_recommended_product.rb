class AddRatingToRecommendedProduct < ActiveRecord::Migration
  def change
    add_column :recommended_products, :rating, :integer
  end
end
