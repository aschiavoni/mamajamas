# coding: utf-8
module UserDecorator
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
end
