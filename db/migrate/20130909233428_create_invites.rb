class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :provider
      t.string :uid
      t.string :email
      t.string :name
      t.string :picture_url
      t.datetime :invite_sent_at

      t.timestamps null: false
    end
  end
end
