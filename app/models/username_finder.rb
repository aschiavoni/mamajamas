class UsernameFinder
  def initialize(requested, user_class = User)
    @requested = requested.downcase
    @user_class = user_class
  end

  def self.find(requested)
    self.new(requested).find
  end

  def find
    next_username = requested
    idx = 0
    while user_class.find_by_username(next_username).present?
      idx += 1
      next_username = "#{requested}#{idx}"
    end
    next_username.gsub(/[^0-9a-z]/i, '')
  end

  private

  def requested
    @requested
  end

  def user_class
    @user_class
  end
end
