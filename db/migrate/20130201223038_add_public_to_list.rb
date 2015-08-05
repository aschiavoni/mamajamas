class AddPublicToList < ActiveRecord::Migration
  def change
    add_column :lists, :public, :boolean, default: false, null: false
  end
end
