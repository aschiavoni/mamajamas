namespace :mamajamas do

  namespace :backfills do

    desc "Backfill full name on address"
    task backfill_full_name_on_address: :environment do
      Address.where(addressable_type: 'User').each do |address| 
        user = address.addressable
        if user.present?
          full_name = user.full_name
          if full_name.present?
            address.full_name = full_name
            address.save!
          end
        end
      end
    end

  end

end
