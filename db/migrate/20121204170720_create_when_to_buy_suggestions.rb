class CreateWhenToBuySuggestions < ActiveRecord::Migration
  def change
    create_table :when_to_buy_suggestions do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
  end
end
