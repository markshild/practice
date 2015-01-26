class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])

  end

  def admin
    current_user.admin
  end

  def signed_in?
    !!current_user
  end

  def login(user)
    @current_user = user
    session[:session_token] = user.reset_token!
  end

  def logout
    current_user.try(:reset_token!)
    session[:session_token] = nil
  end

  def require_login
    redirect_to new_session_url unless signed_in?
  end

  def require_login
    unless signed_in?
      redirect_to new_session_url
    end
  end
  def require_admin
    unless admin
      redirect_to new_session_url
    end
  end

end
