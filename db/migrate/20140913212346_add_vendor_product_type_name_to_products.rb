class AddVendorProductTypeNameToProducts < ActiveRecord::Migration
  def change
    add_column :products, :vendor_product_type_name, :string
  end
end
