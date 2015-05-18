class ChangePictureUrlToTextColumnOnInvite < ActiveRecord::Migration
  def up
    change_column :invites, :picture_url, :text, limit: nil
  end

  def down
    change_column :invites, :picture_url, :string
  end
end
