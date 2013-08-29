class ListBuilderWorker
  include Sidekiq::Worker
  include WorkerLogger

  def perform(user_id)
    log "Looking for user #{user_id}..."
    user = User.find(user_id)
    log "Found user. Building list..."
    user.build_list!
    log "Done"
  end
end
