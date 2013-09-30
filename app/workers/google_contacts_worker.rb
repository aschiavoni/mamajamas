class GoogleContactsWorker
  include Sidekiq::Worker
  include WorkerLogger

  def perform(user_id)
    user = User.find(user_id)
    auth = user.authentications.google.first
    return unless auth.present?

    fetcher = GoogleContactsFetcher.new(auth, GOOGLE_AUTH_CONFIG["app_id"],
                                        GOOGLE_AUTH_CONFIG["secret_key"],
                                        GOOGLE_AUTH_CONFIG["scope"])

    contacts = fetcher.contacts || []
    social_friends = user.social_friends.google.first
    if social_friends.present?
      social_friends.update_attributes!(friends: contacts)
    else
      user.social_friends.create!({
        provider: "google",
        friends: contacts
      })
    end
  end
end
