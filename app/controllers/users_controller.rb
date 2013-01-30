class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view

  def edit
  end

  def update
    respond_to do |format|
      if @profile.update!(params[:profile])
        format.html do
          redirect_to profile_path, notice: "Your profile has been updated."
        end
        format.json
      else
        format.html do
          render action: "edit"
        end
        format.json
      end
    end
  end

  private

  def init_view
    @profile = Forms::UserProfile.new(current_user, current_user.list)
    @page_id = "create-profile"
    @subheader = "Create my profile"
  end
end
