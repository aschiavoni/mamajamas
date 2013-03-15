class QuizController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view, only: [ :show ]

  respond_to :json

  def show
  end

  def update_kid
    @kid = current_user.kids.first
    if @kid.present?
      @kid.update_attributes!(params[:kid])
    else
      @kid = Kid.create!(params[:kid]) do |kid|
        kid.user_id = current_user.id
      end
    end

    respond_with @kid
  end

  private

  def init_view
    set_progress_id 1
  end
end
