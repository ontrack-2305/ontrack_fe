class HolidayFacade
  def self.upcoming_holidays
    holidays = HolidayService.get_holidays
    holidays.map do |holiday|
      Holiday.new(holiday)
    end
  end
end