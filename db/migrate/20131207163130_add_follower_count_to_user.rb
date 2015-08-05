class AddFollowerCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :follower_count, :integer, null: false, default: 0
  end
end
