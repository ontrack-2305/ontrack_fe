class CalendarEvent
  attr_reader :name,
              :start_date,
              :description

  def initialize(data)
    @name = data["summary"]
    @start_date = data["start"]["dateTime"]
    @description = data["description"]
  end
end