class AddSearchFieldsToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :search_index, :string, default: 'All', nil: false
    add_column :product_types, :search_query, :string
  end
end
