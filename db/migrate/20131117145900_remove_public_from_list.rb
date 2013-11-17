class RemovePublicFromList < ActiveRecord::Migration
  def up
    remove_column :lists, :public
  end

  def down
    add_column :lists, :public, :boolean, default: false, null: false
  end
end
