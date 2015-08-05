class RenameWhenToBuySuggestionIdToAgeRangeId < ActiveRecord::Migration
  def change
    rename_column :product_types, :when_to_buy_suggestion_id, :age_range_id
    rename_column :list_items, :when_to_buy_suggestion_id, :age_range_id
  end
end
