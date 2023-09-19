class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    @user = current_user
    @mood = params[:mood] || cookies[:mood]
    @task = TasksFacade.new.task_by_mood(@user.id, @mood) if @mood.present?
  end
end