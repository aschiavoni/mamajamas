class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html do
          render action: "edit", notice: 'User was successfully updated.'
        end
        format.json do
          head :no_content
        end
      else
        format.html do
          render action: "edit"
        end
        format.json do
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
