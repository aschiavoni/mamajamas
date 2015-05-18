namespace :mamajamas do

  namespace :backfills do

    desc "Change all items with a pre-birth age to 0-3 months"
    task backfill_prebirth_age: :environment do
      pre_birth = AgeRange.find_by_name("Pre-birth")
      zero_to_three = AgeRange.find_by_name("0-3 mo")

      if pre_birth.present? && zero_to_three.present?
        ListItem.update_all({ age_range_id: zero_to_three.id },
                            { age_range_id: pre_birth.id })
        ProductType.update_all({ age_range_id: zero_to_three.id },
                               { age_range_id: pre_birth.id })
      end
    end

  end
end
