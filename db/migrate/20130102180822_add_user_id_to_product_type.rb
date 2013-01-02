class AddUserIdToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :user_id, :integer, null: true
  end
end
