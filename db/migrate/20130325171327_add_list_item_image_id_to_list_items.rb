class AddListItemImageIdToListItems < ActiveRecord::Migration
  def change
    add_column :list_items, :list_item_image_id, :integer
  end
end
