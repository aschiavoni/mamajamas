class AddPriceToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :price, :string
  end
end
