class CalendarEventFacade
  def calendar_events
    service = DatabaseService.new
    response = service.get_calendar_events(current_user)
    parsed_response = JSON.parse(response.body)
    parsed_response[:data].map do |event|
      CalendarEvent.new(event)
    end
  end
end