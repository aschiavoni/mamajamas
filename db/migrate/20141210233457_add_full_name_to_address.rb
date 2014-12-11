class AddFullNameToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :full_name, :string
  end
end
