class AddPluralNameToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :plural_name, :string
  end
end
