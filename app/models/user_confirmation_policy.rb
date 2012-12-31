class UserConfirmationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def requires_confirmation_prompt?(sent_within = 48.hours, now = Time.now.utc)
    confirmation_sent_at = user.confirmation_sent_at
    if confirmation_sent_at.present?
      now - confirmation_sent_at > sent_within
    else
      false
    end
  end
end
