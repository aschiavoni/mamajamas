class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.string :name
      t.string :gender
      t.date :birthday
      t.references :age_range
      t.references :user

      t.timestamps
    end
    add_index :kids, :age_range_id
    add_index :kids, :user_id
  end
end
