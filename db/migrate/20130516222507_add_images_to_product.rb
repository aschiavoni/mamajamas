class AddImagesToProduct < ActiveRecord::Migration
  def change
    add_column :products, :medium_image_url, :string
    add_column :products, :large_image_url, :string
  end
end
