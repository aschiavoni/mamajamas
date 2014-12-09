class AddListIdToInvite < ActiveRecord::Migration
  def change
    add_reference :invites, :list, index: true
  end
end
