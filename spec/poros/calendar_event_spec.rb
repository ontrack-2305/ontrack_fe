require 'rails_helper'

RSpec.describe CalendarEvent do
  describe '#initialize' do
    it 'initializes a CalendarEvent object with the provided data' do
      event_data = {
        "name" => "Test Event",
        "start_date" => "09/26/2023 16:00:00",
        "description" => "This is a test event"
      }

      calendar_event = CalendarEvent.new(event_data)

      expect(calendar_event.name).to eq("Test Event")
      expect(calendar_event.start_date).to eq("09/26/2023 16:00:00")
      expect(calendar_event.description).to eq("This is a test event")
    end
  end
end
