class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user
      t.string :provider
      t.string :uid
      t.string :access_token
      t.datetime :access_token_expires_at

      t.timestamps null: false
    end
    add_index :authentications, :user_id
  end
end
