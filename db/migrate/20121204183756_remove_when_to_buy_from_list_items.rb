class RemoveWhenToBuyFromListItems < ActiveRecord::Migration
  def up
    remove_column :list_items, :when_to_buy
  end

  def down
    add_column :list_items, :when_to_buy, :string
  end
end
