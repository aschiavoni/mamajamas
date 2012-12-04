class RemoveWhenToBuyFromProductTypes < ActiveRecord::Migration
  def up
    remove_column :product_types, :when_to_buy
  end

  def down
    add_column :product_types, :when_to_buy, :string
  end
end
