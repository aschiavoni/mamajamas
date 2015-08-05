class CreateListItemImages < ActiveRecord::Migration
  def change
    create_table :list_item_images do |t|
      t.references :user
      t.string :image
      t.timestamps null: false
    end
    add_index :list_item_images, :user_id
  end
end
