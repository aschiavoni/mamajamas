class UsersController < ApplicationController
  include Devise::Controllers::Rememberable

  before_filter :authenticate_user!
  before_filter { |c| c.set_facebook_ad_conversion_params '6014528473678' }

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

    # handle honeypot value
    # if username is included, don't do anything and redirect to
    # root
    if params[:user].present? && params[:user][:username].present?
      redirect_to list_path and return
    end

    @redirect_path = complete_redirect_path
    @profile = Forms::CompleteProfile.new(current_user)
    uparams = params[:profile] || params[:user]
    uparams.delete(:username) # username is a honeypot field

    respond_to do |format|
      if @profile.update!(uparams)
        sign_in @profile.user, bypass: true
        @profile.user.send_welcome_email
        reremember_me!(@profile.user)
        EmailSubscriptionUpdaterWorker.perform_in(5.minutes, @profile.user.id)
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

  def acknowledge_bookmarklet_prompt
    current_user.update_attributes!(show_bookmarklet_prompt: false)
    render json: "ok"
  end

  private

  def init_view(page_id, subheader, progress_step)
    set_page_id page_id
    set_subheader subheader
  end

  def reremember_me!(user)
    cookies.delete :remember_user_token
    remember_me(user)
    user.remember_me!(true)
  end

  def complete_redirect_path
    path = cookies[:after_sign_in_path] || registry_path
    cookies.delete(:after_sign_in_path)
    path
  end
end
