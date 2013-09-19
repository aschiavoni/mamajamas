class Admin::UsersView
  def initialize
  end

  def registered
    @registered ||= User.registered
  end

  def registered_csv
    Admin::UsersCsvReport.new(registered).generate
  end
end
