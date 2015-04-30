class AddReferredByToUser < ActiveRecord::Migration
  def change
    add_reference :users, :referred_by, index: true
  end
end
