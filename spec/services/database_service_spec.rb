require "rails_helper"

RSpec.describe DatabaseService do
  it "connects to database" do
    service = DatabaseService.new
    response = service.connection 
    expect(response).to be_a(Faraday::Connection)
  end

  xit "retrieves a task" do
    service = DatabaseService.new
    # response = service.get_task("1")
    response = stub_request(:get, "http://our_render_url.com/api/v1/users/1/tasks/1").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v2.7.11'
      }).
    to_return(status: 200, body: "", headers: {})

  end

  xit "accepts a request to post a new task" do
    service = DatabaseService.new
    response = service.post({"name"=>"Water Plants",
      "category"=>"Chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"Weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, "1") 

      #pending OAuth working
  end

  xit "updates a task" do

  end
end