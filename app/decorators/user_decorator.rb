# coding: utf-8
module UserDecorator
  include Rails.application.routes.url_helpers
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

  def display_owner_name
    n = display_first_name_or_username
    pn = partner_full_name
    if pn.present?
      n = "#{n} & #{pn.split.first}".html_safe
    end
    n
  end
  memoize :display_owner_name

  def display_full_name_with_coregistrant
    owner_first_name = display_first_name_or_username
    owner_last_name = last_name
    owner_display_name = display_name

    name = owner_display_name

    pn = partner_full_name
    if pn.present?
      pf, pl = pn.split
      if pf.present? && pl.present?
        name = "#{owner_display_name} and #{pn}"
      else
        name = "#{owner_first_name} and #{pf || pl}"
        name = "#{name} #{owner_last_name}" if owner_last_name.present?
      end
    end

    name
  end
  memoize :display_full_name_with_coregistrant

  def possessive_name
    display_first_name_or_username.possessive
  end

  def possessive_full_name
    display_name.possessive
  end

  def followed_users_with_shared_lists
    followed_users.
      includes(:list).
      where("lists.privacy <> ?", List::PRIVACY_PRIVATE).
      references(:lists).
      order(:first_name)
  end
  memoize :followed_users_with_shared_lists

  def shared_list?
    list.present? && !list.private?
  end
  memoize :shared_list?

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

  def featured_list?
    list.present? && list.featured?
  end

  def expert_list?
    list.present? && list.expert?
  end

  def list_tags
    tags = []
    if list.present?
      tags << "featured" if featured_list?
      tags << "expert" if expert_list?
    end
    tags.join(", ")
  end

  def full_shipping_address
    if address.present?
      address.full_address
    else
      "n/a"
    end
  end

  def admin_url
    admin_user_url(username)
  end

  def referred_user_list
    referred_users.map(&:username).join(',')
  end
  memoize :referred_user_list

  def referred_active_user_list
    ids = referred_active_users.map(&:id)
    User.where(id: ids).map(&:username).join(',')
  end
  memoize :referred_active_user_list

  private

  def formatted_date(ts)
    ts.present? ? ts.to_formatted_s(:long) : nil
  end

  def default_url_options
    { host: 'wwww.mamajamas.com' }
  end
end
