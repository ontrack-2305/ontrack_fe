require "rails_helper"

RSpec.describe DatabaseService, :vcr do
  before(:each) do
    @service = DatabaseService.new
    @attributes_hash = {:name=>"Water Plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Remember plants in bedroom, living room, and balcony", :time_needed=>20}
    # @attributes_hash_with_id = {:id => "26", :name=>"Water Plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Remember plants in bedroom, living room, and balcony", :time_needed=>20}
  end

  it "connects to database" do
    response = @service.connection 
    expect(response).to be_a(Faraday::Connection)
  end

  xit "posts a task" do
    response = @service.post(@attributes_hash, "24")
    message = JSON.parse(response.body, symbolize_names: true)[:message] ##pending update from BE
    expect(message).to eq("'Water Plants' added!")
    fetched = @service.get_tasks("24")
    data = JSON.parse(fetched.body, symbolize_names: true)[:data][-1]
    expect(data[:attributes][:name]).to eq("Water Plants")
  end

  xit "patches a task" do
    @service.post(@attributes_hash, "24")
    response1 = @service.get_tasks("24")
    task_id = JSON.parse(response1.body, symbolize_names: true)[:data][-1][:id]

    response2 = @service.patch({frequency: "daily", id: task_id}, "24")
    message = JSON.parse(response2.body, symbolize_names: true)[:message]
    expect(message).to eq("Changes saved") ##pending update from BE
    
    fetched = @service.get_task(task_id, "24")
    data = JSON.parse(fetched.body, symbolize_names: true)[:data]

    expect(data[:attributes][:name]).to eq("Water Plants")
    expect(data[:attributes][:frequency]).to eq("daily")
  end

  xit "destroys a task" do
    @service.post(@attributes_hash, "24")
    response1 = @service.get_tasks("24")
    task_id = JSON.parse(response1.body, symbolize_names: true)[:data][-1][:id]

    response2 = @service.destroy(task_id, "24")
    message = JSON.parse(response2.body, symbolize_names: true)[:message]
    expect(message).to eq("Changes saved") ##pending update from BE
    
    fetched = @service.get_task(task_id, "24")
    data = JSON.parse(fetched.body, symbolize_names: true)[:data]

    expect(data[:attributes][:name]).to eq("Water Plants")
    expect(data[:attributes][:frequency]).to eq("daily")
  end

  xit "gets one task" do

  end

  xit "gets all tasks for a user" do

  end

  xit "gets an ai breakdown" do

  end
end