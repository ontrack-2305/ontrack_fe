class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    mood = params[:mood]
    @user = current_user
    @task = TasksFacade.new.task_by_mood(@user.id, mood)
    @holidays = HolidayFacade.upcoming_holidays
  end
end