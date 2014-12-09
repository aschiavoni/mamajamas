class AddSubjectToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :subject, :string
  end
end
