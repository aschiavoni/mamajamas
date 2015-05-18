class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.references :user, index: true
      t.references :list_item, index: true, null: false
      t.integer :quantity, null: false, default: 0
      t.boolean :purchased, null: false, default: false
      t.boolean :confirmed, null: false, default: false

      t.timestamps
    end
  end
end
