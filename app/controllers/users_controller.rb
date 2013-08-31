class UsersController < ApplicationController
  before_filter :authenticate_user!

  def edit
    if current_user.guest?
      init_view 'create-profile', 'Complete my profile', 3
      @profile = Forms::CompleteProfile.new(current_user)
    else
      init_view 'create-profile', 'Create my profile', 3
      @profile = Forms::UserProfile.new(current_user, current_user.list)
    end
  end

  def update
    init_view 'create-profile', 'Create my profile', 3
    @profile = Forms::UserProfile.new(current_user, current_user.list)
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

  def complete
    init_view 'create-profile', 'Complete my profile', 3
    @redirect_path = friends_path
    @profile = Forms::CompleteProfile.new(current_user)
    uparams = params[:profile] || params[:user]

    respond_to do |format|
      if @profile.update!(uparams)
        sign_in @profile.user, bypass: true
        @profile.user.send_welcome_email
        reremember_me!(@profile.user)
        format.html do
          redirect_to @redirect_path
        end
        format.json
      else
        format.html { render action: 'edit' }
        format.json
      end
    end
  end

  private

  def init_view(page_id, subheader, progress_step)
    set_page_id page_id
    set_subheader subheader
    set_progress_id progress_step
  end

  def reremember_me!(user)
    cookies.delete :remember_user_token
    Devise::Controllers::Rememberable::Proxy.new(request.env['warden']).remember_me(user)
    user.remember_me!
  end
end
