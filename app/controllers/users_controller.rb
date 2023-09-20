class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    mood = params[:mood]
    @user = current_user
    require 'pry'; binding.pry
    @task = TasksFacade.new.task_by_mood(@user.id, mood)
    @holidays = HolidayFacade.upcoming_holidays
    if params[:calendar] == "true"
      @calendar_events = CalendarEventFacade.new.calendar_events(current_user)
    end
  end
end