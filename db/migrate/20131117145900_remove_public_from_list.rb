# TODO: this migration was a mistake, we need the public column in
# order to a backfill. To fix, I am rolling back this migration,
# making it a no-op, and re-running it on staging
class RemovePublicFromList < ActiveRecord::Migration
  def up
    # remove_column :lists, :public
  end

  def down
    # add_column :lists, :public, :boolean, default: false, null: false
  end
end
