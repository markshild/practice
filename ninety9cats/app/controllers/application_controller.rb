class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  private

  def login_check
    redirect_to root_url if current_user
  end

  def ensure_user_is_owner
    redirect_to root_url unless current_user.id == Cat.find(params[:id]).user_id
  end

end
