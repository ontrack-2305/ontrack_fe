class SessionsController < ApplicationController
  def create
    user = User.update_or_create(request.env['omniauth.auth'])
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
    @user = nil
    redirect_to root_path
  end
end