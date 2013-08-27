class AddBuiltAtToList < ActiveRecord::Migration
  def change
    add_column :lists, :built_at, :datetime
  end
end
