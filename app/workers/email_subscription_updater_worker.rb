class EmailSubscriptionUpdaterWorker
  include Sidekiq::Worker
  include WorkerLogger

  sidekiq_options({ unique: :all })

  def perform(user_id)
    log "Looking for user #{user_id}..."
    user = User.find(user_id)

    email_list = Email::MamajamasList.new

    if user.unsubscribed_all?
      log "Unsubscribing #{user.email}..."
      email_list.unsubscribe(user)
    else
      groups = []
      groups << "Blog" if user.blog_updates_enabled?
      groups << "Product" if user.product_updates_enabled?
      log "Updating subscription groups to #{groups} for #{user.email}..."
      email_list.subscribe(user, groups)
    end
  end
end
