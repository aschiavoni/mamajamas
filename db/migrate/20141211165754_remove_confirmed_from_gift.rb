class RemoveConfirmedFromGift < ActiveRecord::Migration
  def change
    remove_column :gifts, :confirmed, :boolean
  end
end
