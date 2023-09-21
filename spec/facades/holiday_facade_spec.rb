require 'rails_helper'

RSpec.describe HolidayFacade do
  describe "class methods" do
    it "returns a list of holidays", :vcr do
      holidays = HolidayFacade.upcoming_holidays

      expect(holidays).to be_an(Array)
      expect(holidays.first).to be_a(Holiday)
    end
  end
end