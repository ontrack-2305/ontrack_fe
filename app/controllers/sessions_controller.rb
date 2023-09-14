class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.valid?
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      redirect_to "/"
    end
  end
  
  # def create
  #   user_info = request.env['omniauth.auth']
  #   user = User.find_or_create_by(google_id: user_info[:uid])
  #   require 'pry'; binding.pry
  #   user.name = user_info[:info][:name]
  #   user.email = user_info[:info][:email]
  #   user.token = user_info[:credentials][:token]

  #   if user.save
  #     session[:user_id] = user.id 
  #     redirect_to dashboard_path(user.id)
  #   else
  #     flash[:error] = "Invalid credentials"
  #     redirect_to root_path
  #   end
  # end
end