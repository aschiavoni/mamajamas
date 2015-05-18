class CreateQuizAnswers < ActiveRecord::Migration
  def change
    create_table :quiz_answers do |t|
      t.integer :user_id
      t.string :question
      t.text :answers

      t.timestamps null: false
    end
  end
end
