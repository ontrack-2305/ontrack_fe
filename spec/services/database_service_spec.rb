require "rails_helper"

RSpec.describe DatabaseService, :vcr do
  before(:each) do
    @service = DatabaseService.new
    @attributes_hash = {:name=>"Water Plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Remember plants in bedroom, living room, and balcony", :time_needed=>20}
    @user_id = "24"
  end

  after(:each) do
    facade = TasksFacade.new
    begin
      tasks = facade.get_tasks(@user_id)
    rescue
      tasks = []
    end
    tasks.each do |task|
      facade.delete(task.id, @user_id)
    end
  end

  it "connects to database" do
    response = @service.connection 
    expect(response).to be_a(Faraday::Connection)
  end

  it "posts a task" do
    response = @service.post(@attributes_hash, @user_id)

    message = JSON.parse(response.body, symbolize_names: true)[:message]
    expect(message).to eq("'Water Plants' added!")
    fetched = @service.get_tasks(@user_id)
    data = JSON.parse(fetched.body, symbolize_names: true)[:data][-1]
    expect(data[:attributes][:name]).to eq("Water Plants")
  end

  it "patches a task" do
    @service.post(@attributes_hash, @user_id)
    response1 = @service.get_tasks(@user_id)
    task_id = JSON.parse(response1.body, symbolize_names: true)[:data][-1][:id]

    response2 = @service.patch({frequency: "daily", id: task_id}, @user_id)
    message = JSON.parse(response2.body, symbolize_names: true)[:message]
    expect(message).to eq("Changes saved!")
    
    fetched = @service.get_task(task_id, @user_id)
    data = JSON.parse(fetched.body, symbolize_names: true)[:data]

    expect(data[:attributes][:name]).to eq("Water Plants")
    expect(data[:attributes][:frequency]).to eq("daily")
  end

  it "destroys a task" do
    @service.post(@attributes_hash, @user_id)
    response1 = @service.get_tasks(@user_id)
    task_id = JSON.parse(response1.body, symbolize_names: true)[:data][-1][:id]

    response2 = @service.destroy(task_id, @user_id)

    message = JSON.parse(response2.body, symbolize_names: true)[:message]
    expect(message).to eq("'Water Plants' deleted.")
    
    not_found = @service.get_task(task_id, @user_id)
    error = JSON.parse(not_found.body, symbolize_names: true)[:errors][0][:detail]

    expect(error).to eq("Couldn't find Task with 'id'=#{task_id}")
  end

  it "gets one task" do
    @service.post(@attributes_hash, @user_id)
    response1 = @service.get_tasks(@user_id)
    task_id = JSON.parse(response1.body, symbolize_names: true)[:data][-1][:id]

    response2 = @service.get_task(task_id, @user_id)
    task_data = JSON.parse(response2.body, symbolize_names: true)[:data]

    expect(task_data[:id]).to eq(task_id)
    expect(task_data[:attributes][:name]).to eq("Water Plants")
  end

  it "gets all tasks for a user" do
    3.times { @service.post(@attributes_hash, @user_id) }
    response = @service.get_tasks(@user_id)
    
    tasks = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(tasks.count).to eq(3)
  end

  it "gets all tasks, with filter criteria" do
    3.times { @service.post(@attributes_hash, @user_id) }
    @attributes_hash[:frequency] = "monthly"
    2.times { @service.post(@attributes_hash, @user_id) }

    weekly_response = @service.get_tasks(@user_id, {frequency: "weekly"})
    monthly_response = @service.get_tasks(@user_id, {frequency: "monthly"})
    all_tasks_response = @service.get_tasks(@user_id)

    weeklies = JSON.parse(weekly_response.body, symbolize_names: true)[:data]
    monthlies = JSON.parse(monthly_response.body, symbolize_names: true)[:data]
    all = JSON.parse(all_tasks_response.body, symbolize_names: true)[:data]

    expect(weeklies.count).to eq(3)
    expect(monthlies.count).to eq(2)
    expect(all.count).to eq(5)
  end

  it "gets an ai breakdown" do
    response = @service.get_ai_breakdown("Water Plants")
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed).to have_key(:response)
    expect(parsed[:response][0][:text]).to be_a(String)
  end

  it "gets only mandatory tasks on bad days" do
    1.times { @service.post(@attributes_hash, @user_id) }
    3.times { @service.post(@attributes_hash, @user_id) }
    @attributes_hash[:mandatory] = "0"

    response = @service.get_daily_tasks(@user_id, "bad")
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed).to have_key(:data)

    parsed[:data].each do |task|
      expect(task).to have_key(:attributes)
      expect(task[:attributes][:mandatory]).to eq(true)
      expect(task[:attributes][:mandatory]).to_not eq(false)
    end
  end

  it "gets a mixture on good days" do
    1.times { @service.post(@attributes_hash, @user_id) }
    @attributes_hash[:category] = "hobby"
    1.times { @service.post(@attributes_hash, @user_id) }
    @attributes_hash[:category] = "rest"
    2.times { @service.post(@attributes_hash, @user_id) }

    response = @service.get_daily_tasks(@user_id, "good")
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed).to have_key(:data)
    expect(parsed[:data][0][:attributes][:category]).to eq("chore")
    expect(parsed[:data][1][:attributes][:category]).to eq("hobby")
    expect(parsed[:data][2][:attributes][:category]).to eq("rest")
  end

  it "has only hobby and rest on 'meh' days" do
    1.times { @service.post(@attributes_hash, @user_id) }
    @attributes_hash[:category] = "hobby", @attributes_hash[:mandatory] = "0"
    1.times { @service.post(@attributes_hash, @user_id) }
    @attributes_hash[:category] = "rest", @attributes_hash[:mandatory] = "0"
    1.times { @service.post(@attributes_hash, @user_id) }

    response = @service.get_daily_tasks(@user_id, "good")
    parsed = JSON.parse(response.body, symbolize_names: true)
    
    expect(parsed).to have_key(:data)

    expect(parsed[:data][0][:attributes][:category]).to_not eq("chore")
    expect(parsed[:data][0][:attributes][:category]).to eq("rest")
    expect(parsed[:data][1][:attributes][:category]).to eq("chore")
    expect(parsed[:data][2][:attributes][:category]).to eq("hobby")
  end

  describe "consumes the Holiday API" do
    it "returns a list of holidays", :vcr do
      holidays = DatabaseService.new.get_holidays

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

  describe "consumes the calendar API" do
    it "returns a list of calendar events", :vcr do
      events = DatabaseService.new.get_events(@user_id)
# require 'pry'; binding.pry
      expect(events).to be_a(Hash)
    end
  end
end