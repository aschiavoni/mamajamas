class QuizController < ApplicationController
  before_filter :authenticate_user!, except: [ :show ]
  before_filter :allow_guest!, only: [ :show ]
  before_filter :init_view, only: [ :show ]
  before_filter only: [:show] { |c|
    c.set_facebook_ad_conversion_params '6014528490878'
  }

  respond_to :json

  def show
    not_found and return

    @countries = Rails.cache.fetch('countries-all') do
      Country.all.sort.to_json
    end
    @categories = Rails.cache.fetch('categories-all') do
      Category.all.order(:name).to_json(only: [:id, :name])
    end
  end

  def update
    question_name = params[:question].try(:downcase)
    if question_name.present?
      answers = params[:answers] || []
      Quiz::Answer.save_answer!(current_user, question_name, answers)
    end

    if params[:complete_list]
      current_user.complete_quiz!
      CompleteListWorker.perform_async(current_user.id)
    end

    render json: { status: 'ok' }
  end

  def update_kid
    due_date = params[:kid][:due_date]
    if due_date.is_a?(String) && !due_date.empty?
      due_date = Date.strptime(due_date,
                               I18n.t("date.formats.default")) rescue nil
      params[:kid][:due_date] = due_date
    end

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

  def update_zip_code
    zip_code = params[:zip_code].present? ? params[:zip_code].strip : nil
    country = params[:country].present? ? params[:country].strip : 'US'
    current_user.update_attributes(zip_code: zip_code, country_code: country)

    respond_with current_user
  end

  private

  def init_view
    hide_mainnav
  end
end
