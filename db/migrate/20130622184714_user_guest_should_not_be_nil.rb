class UserGuestShouldNotBeNil < ActiveRecord::Migration
  def up
    change_column :users, :guest, :boolean, null: false, default: false
  end

  def down
    change_column :users, :guest, :boolean, null: true, default: nil
  end
end
