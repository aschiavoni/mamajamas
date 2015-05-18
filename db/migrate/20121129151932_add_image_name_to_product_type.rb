class AddImageNameToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :image_name, :string
  end
end
