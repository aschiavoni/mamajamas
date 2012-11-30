class RenameProductTypeBuyBeforeToWhenToBuy < ActiveRecord::Migration
  def change
    change_table :product_types do |t|
      t.rename :buy_before, :when_to_buy
    end
  end
end
