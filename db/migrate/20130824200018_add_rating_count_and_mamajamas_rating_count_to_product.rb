class AddRatingCountAndMamajamasRatingCountToProduct < ActiveRecord::Migration
  def change
    add_column :products, :rating_count, :integer, null: false, default: 0
    add_column :products, :mamajamas_rating_count, :integer, null: false, default: 0
  end
end
