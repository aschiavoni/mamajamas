class RenameUsersCountryToCountryCode < ActiveRecord::Migration
  def change
    rename_column :users, :country, :country_code
  end
end
