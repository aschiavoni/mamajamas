class AddFeaturedAndExpertToList < ActiveRecord::Migration
  def change
    add_column(:lists, :featured, :boolean,
               index: true, null: false, default: false)
    add_column :lists, :expert, :boolean, null: false, default: false
  end
end
