class UsernameGenerator
  def self.from_email(email)
    username_part = email.split("@").first
    username = username_part.dup
    num = 2

    while(User.find_by_username(username).present?)
      username = "#{username_part}_#{num}"
      num += 1
    end

    username
  end
end
