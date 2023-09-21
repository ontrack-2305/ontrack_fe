class HolidayFacade
  def self.upcoming_holidays
    holidays = DatabaseService.new.get_holidays
    holidays[:data].map do |holiday|
      day = Holiday.new(holiday[:attributes])
    end
  end
end
