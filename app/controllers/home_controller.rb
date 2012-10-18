class HomeController < ApplicationController
  def index
    flash[:notice] = "Testing notifications. This will disappear shortly..."
  end
end
