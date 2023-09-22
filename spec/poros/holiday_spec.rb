require 'rails_helper'

RSpec.describe Holiday do
  it 'exists and has attributes' do
    params = {
      "date": "2023-10-09",
      "name": "Columbus Day"
    }

    holiday = Holiday.new(params)

    expect(holiday).to be_a(Holiday)
    expect(holiday.name).to eq("Columbus Day")
    expect(holiday.date).to eq("2023-10-09")
  end
end