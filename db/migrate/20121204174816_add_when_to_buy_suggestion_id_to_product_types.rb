class AddWhenToBuySuggestionIdToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :when_to_buy_suggestion_id, :integer
  end
end
