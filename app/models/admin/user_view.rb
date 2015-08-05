class Admin::UserView
  extend Memoist
  attr_reader :user

  delegate :username, :profile_picture, :full_name, to: :user
  delegate :first_name, :last_name, :email, to: :user

  def initialize(user)
    @user = user
  end

  def list
    @list ||= @user.list
  end

  def list_item_count
    return 0 if list.blank?

    list.list_items.user_items.count
  end

  def list_view_count
    return 0 if list.blank?
    list.view_count
  end

  def list_public_view_count
    return 0 if list.blank?
    list.public_view_count
  end

  def follower_count
    user.followers.count
  end

  def following_count
    user.followed_users.count
  end

  def has_social_connection?
    user.google_connected? || user.facebook_connected?
  end

  def referred_users
    active_user_ids = user.referred_active_users.map(&:id)
    Hash[
         user.referred_users.map { |u|
           [ u, active_user_ids.include?(u.id) ]
         }]
  end
  memoize :referred_users

  def quiz_answers
    @answers ||= Quiz::Answer.most_recent_answers(user.id)
  end
end
