class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @_current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def validate_session
    if session[:user_id].nil?
      redirect_to root_path
      flash[:alert] = "Please Log In"
    end
  end
end
