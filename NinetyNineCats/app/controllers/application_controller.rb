class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    user_session = UserSession.find_by_session_token(session[:session_token])
    user_session.user if user_session
  end

  def login!(user)
    token = UserSession.generate_session_token
    session[:session_token] = token
    UserSession.create(user_id: user.id, session_token: token)
  end

  def check_logged_in
    if current_user
      redirect_to cats_url
    end
  end

  helper_method :current_user
  helper_method :check_logged_in
end
