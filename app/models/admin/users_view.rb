class Admin::UsersView
  def initialize
  end

  def registered
    @registered ||= User.registered
  end

  def registered_csv
    UsersCsvReport.new(registered).generate
  end
end
