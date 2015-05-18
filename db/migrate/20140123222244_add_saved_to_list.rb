class AddSavedToList < ActiveRecord::Migration
  def change
    add_column :lists, :saved, :boolean, default: false, null: false
  end
end
