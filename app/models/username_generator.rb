class UsernameGenerator
  def self.from_email(email)
    return nil if email.blank?

    name = email.split("@").first
    self.new(name).generate
  end

  def self.from_name(name)
    return nil if name.blank?

    _, last = name.split
    if last.present? && last.size >= 3
      un = last.dup.parameterize('')
      User.find_by_username(un).present? ? self.new(name).generate : self.new(un).generate
    else
      self.new(name).generate
    end
  end

  def initialize(name, validator = ReservedNameValidator)
    @name = name
    @validator = validator
  end

  def generate
    return nil if name.blank?

    username_part = name.parameterize("")
    username = username_part.dup
    num = 2
    username = "#{username}_#{num}" if username.size < 3

    while(!@validator.valid_name?(username) || User.find_by_username(username).present?)
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
