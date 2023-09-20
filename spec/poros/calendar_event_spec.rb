require 'rails_helper'

RSpec.describe CalendarEvent do
  describe '#initialize' do
    it 'initializes a CalendarEvent object with the provided data' do
      event_data = {
        "summary" => "Test Event",
        "start" => { "dateTime" => "2023-09-25T10:00:00Z" },
        "description" => "This is a test event"
      }

      calendar_event = CalendarEvent.new(event_data)

      expect(calendar_event.name).to eq("Test Event")
      expect(calendar_event.start_date).to eq("2023-09-25T10:00:00Z")
      expect(calendar_event.description).to eq("This is a test event")
    end
  end
end
