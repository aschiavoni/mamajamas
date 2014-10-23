class AddPartnerFullNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :partner_full_name, :string
  end
end
