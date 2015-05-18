class AddWhenToBuySuggestionIdToListItems < ActiveRecord::Migration
  def change
    add_column :list_items, :when_to_buy_suggestion_id, :integer
  end
end
