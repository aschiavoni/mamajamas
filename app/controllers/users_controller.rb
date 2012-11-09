class UsersController < ApplicationController
  def edit
	@user = User.find(params[:id])
  end

 def update
    @user = User.find(params[:id])

    respond_to do |format|

	  #returns true if parameters are valid, otherwise false
      if @user.update_attributes(params[:user])
		#if regular page request, redirects to user page
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
		format.html { render action: "edit", notice: 'User was successfully updated.' }
		#if json request, no visible response
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
