class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    @user = current_user
    @holidays = HolidayFacade.upcoming_holidays
    @mood = params[:mood]
    if params[:calendar] == "true"
      @calendar_events = CalendarEventFacade.new.calendar_events(current_user)
    end
    if @mood.present?
      cookies[:mood] = { value: @mood, expires: 1.minute.from_now }
    end
    @task = TasksFacade.new.task_by_mood(@user.id, cookies[:mood]) 
  end
end