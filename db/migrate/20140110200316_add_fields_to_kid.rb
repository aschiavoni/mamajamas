class AddFieldsToKid < ActiveRecord::Migration
  def change
    add_column :kids, :due_date, :date
    add_column :kids, :multiples, :boolean, nil: false, default: false
  end
end
