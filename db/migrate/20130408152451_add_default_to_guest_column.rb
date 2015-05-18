class AddDefaultToGuestColumn < ActiveRecord::Migration
  def up
    change_column :users, :guest, :boolean, :default => false
  end

  def up
    change_column :users, :guest, :boolean
  end
end
