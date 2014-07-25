class AddIndexToUserSettingsOnUser < ActiveRecord::Migration
  def up
    execute "CREATE INDEX users_settings ON users USING GIN(settings)"
  end

  def down
    execute "DROP INDEX users_settings"
  end
end
