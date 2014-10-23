class AddRegistryToList < ActiveRecord::Migration
  def change
    add_column :lists, :registry, :boolean, null: false, default: false
  end
end
