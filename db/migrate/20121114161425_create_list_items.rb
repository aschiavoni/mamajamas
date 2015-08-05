class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.references :list
      t.string :name
      t.boolean :owned
      t.string :link
      t.integer :rating
      t.string :when_to_buy
      t.integer :priority
      t.string :notes
      t.string :image_url

      t.timestamps null: false
    end
    add_index :list_items, :list_id
  end
end
