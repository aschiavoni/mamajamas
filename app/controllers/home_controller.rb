class HomeController < ApplicationController
  def index
    redirect_to(list_path) and return if user_signed_in?
  end
end
