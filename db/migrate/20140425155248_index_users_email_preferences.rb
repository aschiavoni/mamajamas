class IndexUsersEmailPreferences < ActiveRecord::Migration
  def up
    execute "CREATE INDEX users_email_preferences ON users USING GIN(email_preferences)"
  end

  def down
    execute "DROP INDEX users_email_preferences"
  end
end
