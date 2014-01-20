class Admin::UsersView
  def initialize
  end

  def registered
    @registered ||= User.registered.includes(:list)
  end

  def registered_csv
    Admin::UsersCsvReport.new(registered).generate
  end

  def recent
    @recent ||= User.registered.where("created_at > ?", 24.hours.ago)
  end
end
