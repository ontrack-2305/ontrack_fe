class SessionsController < ApplicationController
  def omniauth
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.valid?
      session[:user_id] = user.id 
      redirect_to dashboard_path(user.id)
    else
      flash[:error] = "Invalid credentials"
      redirect_to root_path
    end
  end
end