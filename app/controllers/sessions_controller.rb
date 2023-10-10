class SessionsController < ApplicationController
  def create
    if params[:email] && params[:password]
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.email}"
        redirect_to dashboard_path
      else
        flash[:alert] = "Sorry, your credentials are bad."
        redirect_to root_path
      end
    else
      user = User.from_google_auth(request.env['omniauth.auth'])
      if user.errors.present?
        flash[:alert] = user.errors.full_messages.join(', ')
        redirect_to root_path
      else
        session[:user_id] = user.id
        redirect_to dashboard_path
      end
    end
  end

  def destroy
    session.delete(:user_id)
    cookies.delete :mood 
    @user = nil
    redirect_to root_path
  end
end