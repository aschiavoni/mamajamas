require 'csv'

class Admin::UsersCsvReport
  def initialize(users)
    @users = users
  end

  def generate
    CSV.generate do |csv|
      csv << attributes
      users.each do |user|
        user.class.send(:include, UserDecorator)
        csv << values(user)
      end
    end
  end

  private

  def users
    @users
  end

  def attributes
    @attrs ||= [
                :id,
                :username,
                :email,
                :first_name,
                :last_name,
                :created_at,
                :list_item_count,
                :shared_list?,
                :sign_in_count,
                :last_sign_in_at,
                :facebook_connected?,
                :birthday,
                :profile_picture,
                :notes,
                :zip_code,
                :country_code,
                :parent_status,
                :due_date,
                :admin,
                :admin_notes,
                :featured_list?,
                :expert_list?,
                :referred_user_count,
                :referred_active_user_count,
                :admin_url
    ]
  end

  def values(user)
    attributes.map do |attr|
      user.public_send(attr)
    end
  end
end
