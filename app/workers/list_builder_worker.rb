class ListBuilderWorker
  include Sidekiq::Worker
  include WorkerLogger

  def perform(user_id)
    log "1 / 3: Looking for user #{user_id}..."
    user = User.find(user_id)
    log "2 / 3: Found user. Building list..."
    user.build_list!
    log "3 / 3: Done"
  end
end
