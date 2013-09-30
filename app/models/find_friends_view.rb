class FindFriendsView
  FACEBOOK_PROVIDER = "facebook"
  GOOGLE_PROVIDER = "google"

  extend Memoist

  def initialize(user)
    @user = user
  end

  def email_invite
    @email_invite ||= Invite.new do |i|
      i.user = user
      i.provider = "mamajamas"
    end
  end

  def facebook_invites
    user.facebook_friends.map do |friend|
      unless mamajamas_facebook_friend_ids.include?(friend[:id])
        existing_facebook_invites[friend[:id]] ||
          build_invite_from_facebook_friend(friend)
      end
    end.reject { |f| f.blank? }
  end
  memoize :facebook_invites

  def mamajamas_facebook_friends
    user.facebook.mamajamas_friends
  end
  memoize :mamajamas_facebook_friends

  def mamajamas_facebook_friend_ids
    mamajamas_facebook_friends.map(&:uid)
  end
  memoize :mamajamas_facebook_friend_ids

  def existing_facebook_invites
    Hash[user.invites.where(provider: FACEBOOK_PROVIDER).map do |invite|
      [ invite.uid, invite  ]
    end]
  end
  memoize :existing_facebook_invites

  def mamajamas_google_friends_emails
    mamajamas_google_friends.map(&:email)
  end
  memoize :mamajamas_google_friends_emails

  def google_friends_emails
    user.google_friends.map { |f| f[:email] }
  end
  memoize :google_friends_emails

  def mamajamas_google_friends
    User.includes(:list).
      where("users.email" => google_friends_emails).
      where("users.email <> ?", user.email).
      where("lists.public = true")
  end
  memoize :mamajamas_google_friends

  def existing_google_invites
    Hash[user.invites.where(provider: GOOGLE_PROVIDER).map do |invite|
      [ invite.uid, invite  ]
    end]
  end
  memoize :existing_google_invites

  def google_invites
    is = user.google_friends.map do |friend|
      unless mamajamas_google_friends_emails.include?(friend[:email])
        existing_google_invites[friend[:email]] ||
          build_invite_from_google_friend(friend)
      end
    end.reject { |f| f.blank? }
    p is
    is
  end
  memoize :google_invites

  private

  def user
    @user
  end

  def build_invite_from_facebook_friend(friend)
    uid = friend[:id]
    Invite.new do |i|
      i.user_id = user.id
      i.uid = uid
      i.name = friend[:name]
      i.provider = FACEBOOK_PROVIDER
      i.picture_url = FacebookProfilePicture.new(uid, picture_options).url
    end
  end

  def build_invite_from_google_friend(friend)
    uid = friend[:email]
    Invite.new do |i|
      i.user_id = user.id
      i.uid = uid
      i.name = friend[:name]
      i.provider = GOOGLE_PROVIDER
      i.picture_url = GravatarProfilePicture.url(uid, picture_size)
    end
  end

  def picture_options
    @pic_opts ||= { width: picture_size, height: picture_size }
  end

  def picture_size
    @pic_size ||= 86
  end
end
