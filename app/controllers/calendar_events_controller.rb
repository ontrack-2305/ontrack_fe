class CalendarEventsController < ApplicationController
  before_action :validate_session
  
  def index
    service = DatabaseService.new
    service.get_calendar_events(current_user)
    # require 'pry'; binding.pry
    # does this need to be defined at all if there's already a @_current_user?
  end
end
