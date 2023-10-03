class SessionsController < ApplicationController
  def create
    user = User.from_google_auth(request.env['omniauth.auth'])
    if user.errors.present?
      flash[:alert] = user.errors.full_messages.join(', ')
      redirect_to root_path
    else
      session[:user_id] = user.id
      redirect_to dashboard_path
    end
  end

  def destroy
    session.delete(:user_id)
    cookies.delete :mood 
    @user = nil
    redirect_to root_path
  end
end