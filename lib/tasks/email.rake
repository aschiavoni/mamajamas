namespace :mamajamas do
  namespace :email do

    desc "Get unsubscribe list from mailchimp and unsubscribe users"
    task update_unsubscribes: :environment do
      list = Email::MamajamasList.new

      list.unsubscribed.each do |s|
        puts "Looking for #{s['email']}..."
        user = User.find_by_email(s["email"])
        if user.present?
          puts "Found #{s['email']}. Unsubscribing..."
          user.blog_updates_enabled = false
          user.product_updates_enabled = false
          user.save
          puts "Done"
        end
      end
    end

  end
end
