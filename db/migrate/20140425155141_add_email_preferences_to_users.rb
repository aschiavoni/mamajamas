class AddEmailPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_preferences, :hstore, default: '', null: false
  end
end
