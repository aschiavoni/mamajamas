class CompleteListWorker
  include Sidekiq::Worker
  include WorkerLogger

  def perform(user_id)
    log "Looking for user #{user_id}..."
    user = User.find(user_id)

    # build the list again just in case?
    # if it has already been built, it is basically a no-op
    log "Found user. Building list..."
    user.build_list!

    # process questions
    log "List Built. Updating from quiz results..."
    ListQuizUpdater.new(user).update!

    # prune list
    log "List updated. Pruning list..."
    ListPruner.prune!(user.list)

    # complete list
    log "Prune completed. Completing list..."
    user.list.complete!
    log "Done."
  end
end
