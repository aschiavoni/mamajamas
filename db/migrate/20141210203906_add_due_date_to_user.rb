class AddDueDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :baby_due_date, :datetime
  end
end
