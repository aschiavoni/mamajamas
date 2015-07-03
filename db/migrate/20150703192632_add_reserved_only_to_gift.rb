class AddReservedOnlyToGift < ActiveRecord::Migration
  def change
    add_column :gifts, :reserved_only, :boolean, default: false, null: false
  end
end
