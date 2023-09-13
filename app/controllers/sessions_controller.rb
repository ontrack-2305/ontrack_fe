class SessionsController < ApplicationController
  def new
  end
  
  def create
    user_info = request.env['omniauth.auth']
    require 'pry'; binding.pry
    user = User.find_by(google_id: user_info['uid'])

    user ||= User.create!(
      name: user_info['info']['name'],
      email: user_info['info']['email'],
      google_id: user_info['uid']
    )
    if user.valid?
      session[:user_id] = user.id 
      redirect_to dashboard_path(user.id)
    else
      flash[:error] = "Invalid credentials"
      redirect_to root_path
    end
  end
end