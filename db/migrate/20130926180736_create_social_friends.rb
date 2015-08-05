class CreateSocialFriends < ActiveRecord::Migration
  def change
    create_table :social_friends do |t|
      t.references :user
      t.string :provider
      t.text :friends

      t.timestamps null: false
    end
    add_index :social_friends, :user_id
    add_index :social_friends, :provider
  end
end
