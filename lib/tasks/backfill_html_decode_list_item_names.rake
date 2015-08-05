namespace :mamajamas do

  namespace :backfills do

    # this is not perfect and is slow but only needs to be run once
    desc "Html decode all list item names"
    task html_decode_list_item_names: :environment do

      decoder = HTMLEntities.new

      ListItem.user_items.each do |li|
        name = li.name
        name = decoder.decode(name)
        li.name = name

        if li.changed?
          puts "Updating #{li.id} with #{name}"
          li.save!
        end
      end

    end

  end

end
