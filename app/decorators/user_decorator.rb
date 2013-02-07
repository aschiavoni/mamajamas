# coding: utf-8
module UserDecorator
  extend Memoist

  def display_name
    unless first_name.blank? || last_name.blank?
      "#{first_name} #{last_name}"
    else
      username
    end
  end

  def display_first_name_or_username
    first_name.blank? ? username : first_name
  end

  def display_last_name
    last_name
  end

  def possessive_name
    display_first_name_or_username.possessive
  end

  def followed_users_with_public_lists
    followed_users.includes(:list).where("lists.public = true")
  end
  memoize :followed_users_with_public_lists
end
