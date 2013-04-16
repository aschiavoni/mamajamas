class AddCountryToUser < ActiveRecord::Migration
  def change
    add_column :users, :country, :string, default: 'US'
  end
end
