class UsersController < ApplicationController
  before_action :require_admin, only: [:index]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to bands_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def index
    @users = User.all
  end


  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
