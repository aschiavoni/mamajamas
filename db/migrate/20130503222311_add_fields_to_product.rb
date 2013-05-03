class AddFieldsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :sales_rank, :integer
    add_column :products, :brand, :string
    add_column :products, :manufacturer, :string
    add_column :products, :model, :string
    add_column :products, :department, :string
    add_column :products, :categories, :string
  end
end
