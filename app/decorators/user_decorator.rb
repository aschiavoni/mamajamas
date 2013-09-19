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
    followed_users.
      includes(:list).
      where("lists.public = true").
      order(:first_name)
  end
  memoize :followed_users_with_public_lists

  def public_list?
    list.present? && list.public?
  end
  memoize :public_list?

  def list_item_count
    return 0 if list.blank?
    list.list_items.user_items.count
  end

  def signed_up
    formatted_date(created_at)
  end

  def last_sign_in
    formatted_date(last_sign_in_at)
  end

  private

  def formatted_date(ts)
    ts.present? ? ts.to_formatted_s(:long) : nil
  end
end
