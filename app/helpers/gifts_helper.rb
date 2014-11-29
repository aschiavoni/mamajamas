module GiftsHelper
  def gifter_full_name
    if current_user.present?
      current_user.full_name
    else
      cookies[:gifter_full_name]
    end
  end

  def gifter_email
    if current_user.present?
      current_user.email
    else
      cookies[:gifter_email]
    end
  end
end
