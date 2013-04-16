class QuizController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view, only: [ :show ]

  respond_to :json

  def show
    @countries = Country.all.sort.to_json
  end

  def update
    question = Quiz::Question.by_name(params[:question], current_user.list)
    answers = params[:answers] || []
    question.answer(*answers)

    render json: { status: 'ok' }
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

    current_user.build_list! if current_user.list.blank?
    respond_with @kid
  end

  def update_zip_code
    zip_code = params[:zip_code].present? ? params[:zip_code].strip : nil
    country = params[:country].present? ? Country.find_by_name(params[:country].strip).first : 'US'
    current_user.update_attributes!(zip_code: zip_code, country: country)
    render json: { status: 'ok' }
  end

  def prune_list
    ListPruner.prune!(current_user.list)
    render json: { status: 'ok' }
  end

  private

  def init_view
    set_progress_id 1
  end
end
