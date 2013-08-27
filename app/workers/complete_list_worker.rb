class CompleteListWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    # build the list again just in case?
    # if it has already been built, it is basically a no-op
    user.build_list!

    # process questions
    ListQuizUpdater.new(user).update!

    # prune list
    ListPruner.prune!(user.list)

    # complete list
    user.list.complete!
  end
end
