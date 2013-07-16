class AddMamajamasRatingToProduct < ActiveRecord::Migration
  def change
    add_column :products, :mamajamas_rating, :float
  end
end
