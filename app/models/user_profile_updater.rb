class UserProfileUpdater
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def update(user_params, list_params)
    unformatted_birthday = user_params["birthday"]
    if unformatted_birthday.present?
      user_params["birthday"] = Date.strptime(unformatted_birthday, "%m/%d/%Y")
    end
    user.update_attributes(user_params) && user.list.update_attributes(list_params)
  end
end
