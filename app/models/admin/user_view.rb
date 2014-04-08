class Admin::UserView
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

  def quiz_answers
    @answers ||= Quiz::Answer.most_recent_answers(user.id)
  end

  def featured_list?
    list.featured?
  end

  def expert_list?
    list.expert?
  end
end
