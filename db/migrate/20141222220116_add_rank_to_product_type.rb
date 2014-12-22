class AddRankToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :rank, :integer
  end
end
