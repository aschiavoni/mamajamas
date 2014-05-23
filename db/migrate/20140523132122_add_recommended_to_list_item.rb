class AddRecommendedToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :recommended, :boolean, default: false, null: false
  end
end
