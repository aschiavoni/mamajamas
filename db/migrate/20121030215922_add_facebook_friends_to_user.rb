class AddFacebookFriendsToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_friends, :text
    add_column :users, :facebook_friends_updated_at, :datetime
  end
end
