class AddPrivacyToList < ActiveRecord::Migration
  def change
    add_column :lists, :privacy, :integer, null: false, default: 0
  end
end
