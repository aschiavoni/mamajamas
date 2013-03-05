class RenameWhenToBuySuggestionToAgeRange < ActiveRecord::Migration
  def up
    rename_table :when_to_buy_suggestions, :age_ranges
  end

  def down
    rename_table :age_ranges, :when_to_buy_suggestions
  end
end
