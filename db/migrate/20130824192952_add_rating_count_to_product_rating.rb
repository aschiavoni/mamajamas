class AddRatingCountToProductRating < ActiveRecord::Migration
  def change
    add_column :product_ratings, :rating_count, :integer, null: false, default: 0
  end
end
