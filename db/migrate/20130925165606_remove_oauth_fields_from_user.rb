class RemoveOauthFieldsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :uid
    remove_column :users, :provider
    remove_column :users, :access_token
    remove_column :users, :access_token_expires_at
  end

  def down
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :access_token, :string
    add_column :users, :access_token_expires_at, :datetime
  end
end
