class QuizController < ApplicationController
  before_filter :authenticate_user!, except: [ :show ]
  before_filter :allow_guest!, only: [ :show ]
  before_filter :init_view, only: [ :show ]

  respond_to :json

  def show
    @countries = Country.all.sort.to_json
  end

  def update
    question_name = params[:question].downcase
    answers = params[:answers] || []
    Quiz::Answer.save_answer!(current_user, question_name, answers)

    CompleteListWorker.perform_async(current_user.id) if params[:complete_list]

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

    ListBuilderWorker.perform_async(current_user.id)
    respond_with @kid
  end

  def update_zip_code
    zip_code = params[:zip_code].present? ? params[:zip_code].strip : nil
    country = params[:country].present? ? params[:country].strip : 'US'
    current_user.update_attributes(zip_code: zip_code, country_code: country)

    respond_with current_user
  end

  private

  def init_view
    set_progress_id 1
  end
end
