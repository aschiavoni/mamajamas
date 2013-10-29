class AddRatingDefaultForListItem < ActiveRecord::Migration
  def up
    change_column :list_items, :rating, :integer, default: 0
  end

  def down
    change_column :list_items, :rating, :integer, default: nil
  end
end
