class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    require 'pry'; binding.pry
    if params[:calendar] == "true"
      service = DatabaseService.new
      response = service.get_calendar_events(current_user)
      parsed_response = JSON.parse(response.body)
    end
      mood = params[:mood]
      @user = current_user
      @task = TasksFacade.new.task_by_mood(@user.id, mood)
      @holidays = HolidayFacade.upcoming_holidays
  end
end