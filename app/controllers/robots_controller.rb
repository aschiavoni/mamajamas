class RobotsController < ApplicationController
  layout false

  def show
    robots_file = Rails.env.production? ? 'allow.txt' : 'disallow.txt'
    render robots_file, :content_type => 'text/plain'
  end
end
