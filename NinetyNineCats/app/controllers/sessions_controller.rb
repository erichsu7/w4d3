class SessionsController < ApplicationController
  before_action :check_logged_in, only: [:new]

  def create
    user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])

    if user
      login!(user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

  def new
    render :new
  end

end
