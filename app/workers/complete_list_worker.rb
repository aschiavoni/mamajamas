class CompleteListWorker
  include Sidekiq::Worker
  include WorkerLogger

  def perform(user_id)
    log "1 / 7: Looking for user #{user_id}..."
    user = User.find(user_id)

    # build the list again just in case?
    # if it has already been built, it is basically a no-op
    log "2 / 7: Found user. Building list..."
    user.build_list!

    # process questions
    log "3 / 7: List Built. Updating from quiz results..."
    ListQuizUpdater.new(user).update!

    # add recommended products
    log "4 / 7: Adding recommended products, if applicable"
    ListRecommendationService.new(user).update! if !user.build_custom_list?

    # prune list
    log "5 / 7: List updated. Pruning list..."
    ListPruner.prune!(user.list)

    # complete list
    log "6 / 7: Prune completed. Completing list..."
    user.list.complete!

    log "7 / 7: Done."
  end
end
