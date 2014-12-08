class GiftNotificationWorker
  include Sidekiq::Worker
  include WorkerLogger

  def perform(gift_id)
    GiftMailer.gift_received(gift_id).deliver
    GiftMailer.gift_given(gift_id).deliver
  end
end
