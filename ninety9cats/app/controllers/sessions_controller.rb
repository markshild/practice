class SessionsController < ApplicationController
  before_action :login_check, except: :destroy

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params[:user_name], user_params[:password])
    if @user
      login!(@user)
      redirect_to root_url
    else
      @user = User.new(user_params)
      render :new
    end

  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
