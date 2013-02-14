class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view

  def edit
  end

  def update
    respond_to do |format|
      if @profile.update!(params[:profile])
        format.html do
          redirect_to public_list_preview_list_path
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
    set_page_id "create-profile"
    set_subheader "Create my profile"
    set_progress_id 3
  end
end
