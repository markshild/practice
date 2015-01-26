class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_creds(params[:user][:email], params[:user][:password])
    if @user
      login(user)
      redirect_to bands_url
    else
      flash.now[:errors] = ["Could not find user with those credentials"]
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end


end
