class SessionsController < ApplicationController
  def create
    user = User.update_or_create(request.env['omniauth.auth'])
    if user.valid?
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      redirect_to "/"
    end
  end
end