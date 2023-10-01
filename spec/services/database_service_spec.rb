require "rails_helper"

RSpec.describe DatabaseService, :vcr do
  include OmniauthModule

  before(:each) do
    @service = DatabaseService.new
    @attributes_hash = {:name=>"Water Plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Remember plants in bedroom, living room, and balcony"}
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

  describe "mood button functionality" do
    before(:each) do
      @service = DatabaseService.new
      @user_id = "24"

      @service.post({"name"=>"Take Vitamins",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>"flintstone gummies all dayeee"}, @user_id)
    
      @service.post({"name"=>"crochet",
      "category"=>"hobby",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"granny squares"}, @user_id)

      @service.post({"name"=>"read a book",
      "category"=>"rest",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>"smut"}, @user_id)

      @service.post({"name"=>"go on a walk",
      "category"=>"rest",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>""}, @user_id)

      @service.post({"name"=>"practice juggling",
      "category"=>"hobby",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"monthly",
      "notes"=>"bowling balls, bowling pins"}, @user_id)

      @service.post({"name"=>"do the dishes",
      "category"=>"chore",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>""}, @user_id)
    end
    
    it "gets only mandatory and rest tasks on bad days" do
      response = @service.get_daily_tasks(@user_id, "bad")
      parsed = JSON.parse(response.body, symbolize_names: true)
      
      expect(parsed).to have_key(:data)
      expect(parsed[:data][0][:attributes][:name]).to eq("Take Vitamins")
      expect(parsed[:data][0][:attributes][:mandatory]).to eq(true)
      expect(parsed[:data][1][:attributes][:name]).to eq("go on a walk")
      expect(parsed[:data][1][:attributes][:mandatory]).to eq(true)
      expect(parsed[:data][2][:attributes][:name]).to eq("read a book")
      expect(parsed[:data][2][:attributes][:category]).to eq("rest")
      expect(parsed[:data][2][:attributes][:mandatory]).to eq(false)
    end

    it "gets a mixture on good days" do
      response = @service.get_daily_tasks(@user_id, "good")
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data][0][:attributes][:category]).to eq("chore")
      expect(parsed[:data][0][:attributes][:mandatory]).to eq(true)
      expect(parsed[:data][1][:attributes][:category]).to eq("rest")
      expect(parsed[:data][1][:attributes][:mandatory]).to eq(true)
      expect(parsed[:data][2][:attributes][:category]).to eq("chore")
      expect(parsed[:data][2][:attributes][:mandatory]).to eq(false)
      expect(parsed[:data][3][:attributes][:category]).to eq("hobby")
      expect(parsed[:data][2][:attributes][:mandatory]).to eq(false)
    end

    it "has only mandatory, hobby and rest on 'meh' days" do
      response = @service.get_daily_tasks(@user_id, "meh")
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data][0][:attributes][:name]).to eq("Take Vitamins")
      expect(parsed[:data][0][:attributes][:category]).to eq("chore")
      expect(parsed[:data][0][:attributes][:mandatory]).to eq(true)
      expect(parsed[:data][1][:attributes][:name]).to eq("go on a walk")
      expect(parsed[:data][1][:attributes][:category]).to eq("rest")
      expect(parsed[:data][1][:attributes][:mandatory]).to eq(true)
      expect(parsed[:data][2][:attributes][:name]).to eq("crochet")
      expect(parsed[:data][2][:attributes][:category]).to eq("hobby")
      expect(parsed[:data][2][:attributes][:mandatory]).to eq(false)
      expect(parsed[:data][3][:attributes][:name]).to eq("practice juggling")
      expect(parsed[:data][3][:attributes][:category]).to eq("hobby")
      expect(parsed[:data][3][:attributes][:mandatory]).to eq(false)
    end
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
end