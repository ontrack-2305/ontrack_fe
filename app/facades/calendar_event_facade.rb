class CalendarEventFacade
  def calendar_events(current_user)
    service = DatabaseService.new
    response = service.get_calendar_events(current_user)
    parsed_response = JSON.parse(response.body)
    events_data = parsed_response['data']
    calendar_events = events_data.map do |event_data|
      event_attributes = event_data['attributes']
      CalendarEvent.new(event_attributes)
    end
  end
end