class QuizController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view, only: [ :show ]

  def show
  end

  private

  def init_view
    set_progress_id 1
  end
end
