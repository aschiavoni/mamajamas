class UsernameGenerator
  def self.from_email(email)
    return nil if email.blank?

    name = email.split("@").first
    self.new(name).generate
  end

  def self.from_name(name)
    self.new(name).generate
  end

  def initialize(name)
    @name = name
  end

  def generate
    return nil if name.blank?

    username_part = name.parameterize("")
    username = username_part.dup
    num = 2

    while(User.find_by_username(username).present?)
      username = "#{username_part}_#{num}"
      num += 1
    end

    username
  end

  private

  def name
    @name
  end
end
