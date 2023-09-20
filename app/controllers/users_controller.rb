class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    @user = current_user
    @mood = params[:mood]
    @task = TasksFacade.new.task_by_mood(@user.id, @mood) 
    if @mood.present?
      cookies[:mood] = { value: @mood, expires: 1.year.from_now }
    end
  end
end