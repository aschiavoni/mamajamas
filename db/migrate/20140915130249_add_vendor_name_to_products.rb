class AddVendorNameToProducts < ActiveRecord::Migration
  def change
    add_column :products, :vendor_name, :string
  end
end
