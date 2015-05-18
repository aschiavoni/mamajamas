class AddAliasesToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :aliases, :text, array: true, default: []
  end
end
