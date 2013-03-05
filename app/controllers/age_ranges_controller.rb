class AgeRangesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @age_ranges = AgeRange.order(:position)
    respond_with @age_ranges
  end
end
