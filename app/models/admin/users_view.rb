class Admin::UsersView
  def initialize
  end

  def registered
    @registered ||= User.registered
  end
end
