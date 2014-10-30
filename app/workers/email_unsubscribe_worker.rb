class EmailUnsubscribeWorker
  include Sidekiq::Worker
  include WorkerLogger

  sidekiq_options({ unique: :all })

  def perform(email)
    return if Rails.env.test?
    Email::MamajamasList.new.unsubscribe_email(email)
  end
end
