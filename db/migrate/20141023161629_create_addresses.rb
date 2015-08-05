class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :street2
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country_code
      t.references :addressable, polymorphic: true

      t.timestamps
    end
  end
end
