class CalendarEvent
  attr_reader :name,
              :start_date,
              :description

  def initialize(data)
    @name = data["name"]
    @start_date = data["start_date"]
    @description = data["description"]
  end
end