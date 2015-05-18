class IncreaseLimitOnListItemLink < ActiveRecord::Migration
  def up
    change_column :list_items, :link, :string, limit: 1999
  end

  def down
    change_column :list_items, :link, :string, limit: 255
  end
end
