class CalendarEventFacade
  def calendar_events(current_user)
    service = DatabaseService.new
    response = service.get_calendar_events(current_user)
    parsed_response = JSON.parse(response.body)
    # require 'pry'; binding.pry
    parsed_response[:data].map do |event|
      truth = CalendarEvent.new(event)
    end
  end
end