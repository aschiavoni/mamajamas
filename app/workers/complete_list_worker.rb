class CompleteListWorker
  include Sidekiq::Worker
  include WorkerLogger

  def perform(user_id)
    log "1 / 6: Looking for user #{user_id}..."
    user = User.find(user_id)

    # build the list again just in case?
    # if it has already been built, it is basically a no-op
    log "2 / 6: Found user. Building list..."
    user.build_list!

    # process questions
    log "3 / 6: List Built. Updating from quiz results..."
    ListQuizUpdater.new(user).update!

    # prune list
    log "4 / 6: List updated. Pruning list..."
    ListPruner.prune!(user.list)

    # complete list
    log "5 / 6: Prune completed. Completing list..."
    user.list.complete!
    log "6 / 6: Done."
  end
end
