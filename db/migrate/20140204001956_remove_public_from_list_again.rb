class RemovePublicFromListAgain < ActiveRecord::Migration
  def up
    if column_exists? :lists, :public
      remove_column :lists, :public
    end
  end

  def down
    unless column_exists? :lists, :public
      add_column :lists, :public, :boolean, default: false, null: false
    end
  end
end
