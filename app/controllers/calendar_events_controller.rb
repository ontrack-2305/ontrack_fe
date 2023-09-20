class CalendarEventsController < ApplicationController
  before_action :validate_session
  
  def index
    service = DatabaseService.new
    response = service.get_calendar_events(current_user)
    parsed_response = JSON.parse(response.body)
  end
end
