class AddSetupRegistryToUser < ActiveRecord::Migration
  def change
    add_column :users, :setup_registry, :boolean, null: false, default: false
  end
end
