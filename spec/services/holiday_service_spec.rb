require 'rails_helper'

RSpec.describe HolidayService do
  describe "consumes the Holiday API" do
    it "returns a list of holidays", :vcr do
      holidays = HolidayService.get_holidays

      expect(holidays).to be_a(Hash)
      expect(holidays).to have_key(:data)
      expect(holidays[:data]).to be_an(Array)

      holidays[:data].each do |holiday|
        expect(holiday).to have_key(:type)
        expect(holiday[:type]).to be_a(String)
        expect(holiday).to have_key(:attributes)
        expect(holiday[:attributes]).to be_a(Hash)

        expect(holiday[:attributes]).to have_key(:name)
        expect(holiday[:attributes][:name]).to be_a(String)
        expect(holiday[:attributes]).to have_key(:date)
        expect(holiday[:attributes][:date]).to be_a(String)
      end
    end
  end
end