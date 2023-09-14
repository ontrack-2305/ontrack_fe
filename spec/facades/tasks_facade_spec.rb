require "rails_helper"

RSpec.describe TasksFacade do
  it "can post a task" do
    json_response = {message: "'Water Plants' added!"}.to_json
    stub_request(:post, "http://our_render_url.com/api/v1/users/1/tasks?event_date=&frequency=Weekly&mandatory=1&name=Water%20Plants&notes=Remember%20plants%20in%20bedroom,%20living%20room,%20and%20balcony&time_needed=20&category=Chore").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Length'=>'0',
          'User-Agent'=>'Faraday v2.7.11'
           }).
         to_return(status: 200, body: json_response)
    
    facade = TasksFacade.new 
    response = facade.post({"name"=>"Water Plants",
      "category"=>"Chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"Weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, "1")

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response[:message]).to eq("'Water Plants' added!")
  end

  it "can fetch all tasks" do
    json_response = File.read("spec/fixtures/mock_tasks.json")
    stub_request(:get, "http://our_render_url.com/api/v1/users/2/tasks").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v2.7.11'
      }).
    to_return(status: 200, body: json_response)


    facade = TasksFacade.new
    tasks = facade.get_tasks("2")
    expect(tasks).to be_an(Array)
    expect(tasks).to all be_a(Task)
  end

  it "can update a task" do
    json_response = {message: "Changes saved!"}.to_json
    stub_request(:patch, "http://our_render_url.com/api/v1/users/1/tasks/?category=Chore&event_date=&frequency=Weekly&mandatory=1&name=Water%20Plants&notes=Remember%20plants%20in%20bedroom,%20living%20room,%20and%20balcony&time_needed=20").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Length'=>'0',
          'User-Agent'=>'Faraday v2.7.11'
           }).
         to_return(status: 200, body: json_response)

    facade = TasksFacade.new
    response = facade.patch({"name"=>"Water Plants",
      "category"=>"Chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"Weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, "1")
    
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:message]).to eq("Changes saved!")
  end
end