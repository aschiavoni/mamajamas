class AddRelationshipsCreatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :relationships_created_at, :datetime
  end
end
