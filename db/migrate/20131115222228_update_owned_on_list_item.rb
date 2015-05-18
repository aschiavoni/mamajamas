class UpdateOwnedOnListItem < ActiveRecord::Migration
  def up
    change_column(:list_items, :owned, :boolean, default: false, null: false)
  end

  def down
    change_column(:list_items, :owned, :boolean, null: true)
  end
end
