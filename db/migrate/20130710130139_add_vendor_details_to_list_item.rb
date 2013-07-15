class AddVendorDetailsToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :vendor, :string
    add_column :list_items, :vendor_id, :string
  end
end
