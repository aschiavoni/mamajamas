class AddRankToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :rank, :integer
  end
end
