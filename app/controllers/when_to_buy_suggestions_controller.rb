class WhenToBuySuggestionsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @suggestions = WhenToBuySuggestion.order(:position)
    respond_with @suggestions
  end
end
