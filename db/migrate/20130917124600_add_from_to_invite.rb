class AddFromToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :from, :string
  end
end
