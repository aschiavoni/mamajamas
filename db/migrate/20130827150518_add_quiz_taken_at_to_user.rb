class AddQuizTakenAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :quiz_taken_at, :datetime
  end
end
