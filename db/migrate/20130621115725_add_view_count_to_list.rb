class AddViewCountToList < ActiveRecord::Migration
  def change
    add_column :lists, :view_count, :integer, default: 0, null: false
    add_column :lists, :public_view_count, :integer, default: 0, null: false
  end
end
