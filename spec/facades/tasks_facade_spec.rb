require "rails_helper"

RSpec.describe TasksFacade, :vcr do
  before(:each) do
    @user_id = "20"
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

  it "can post a task" do    
    facade = TasksFacade.new 
    expect(facade.get_tasks(@user_id).count).to eq(0)
    response = facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)

    expect(facade.get_tasks(@user_id).count).to eq(1)
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response[:message]).to eq("'Water Plants' added!")
  end

  it "can fetch all tasks" do
    facade = TasksFacade.new
    facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)
    facade.post({"name"=>"Prune Plants",
        "category"=>"chore",
        "mandatory"=>"1",
        "event_date"=>"",
        "frequency"=>"weekly",
        "notes"=>"Remember plants in bedroom, living room, and balcony",
        "time_needed"=>20}, @user_id)

    tasks = facade.get_tasks(@user_id)
    expect(tasks).to be_an(Array)
    expect(tasks).to all be_a(Task)
    expect(tasks.count).to eq(2)
  end

  it "can filter all tasks by criteria" do
    facade = TasksFacade.new
    facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)
    facade.post({"name"=>"Prune Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "frequency"=>"monthly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)
    facade.post({"name"=>"Take Bath",
      "category"=>"rest",
      "mandatory"=>"0",
      "frequency"=>"monthly",
      "notes"=>"Light a candle and have some music and relax!",
      "time_needed"=>60}, @user_id)

    mandatory_tasks = facade.get_tasks(@user_id, {mandatory: true})
    expect(mandatory_tasks).to be_an(Array)
    expect(mandatory_tasks).to all be_a(Task)
    expect(mandatory_tasks.count).to eq(2)
    expect(mandatory_tasks[0].name).to eq("Water Plants")
    expect(mandatory_tasks[1].name).to eq("Prune Plants")

    monthly_tasks = facade.get_tasks(@user_id, {frequency: :monthly})
    expect(monthly_tasks.count).to eq(2)
    expect(monthly_tasks[0].name).to eq("Prune Plants")
    expect(monthly_tasks[1].name).to eq("Take Bath")
  end

  it "can update a task" do
    facade = TasksFacade.new
    facade.post({
      "name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)

    task = facade.get_tasks(@user_id).last

    response = facade.patch({notes: "Different notes", id: task.id}, @user_id)

    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:message]).to eq("Changes saved!")
  end

  it "can get one task" do
    facade = TasksFacade.new
    facade.post({"name"=>"Repot Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)
    tasks = facade.get_tasks(@user_id)

    task = facade.get_task(tasks.last.id, @user_id)
    expect(task).to be_a(Task)
    expect(task.name).to eq("Repot Plants")
  end

  it "can delete a task" do
    facade = TasksFacade.new
    facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)
    tasks = facade.get_tasks(@user_id)
    task = facade.get_task(tasks.first.id, @user_id)
    expect(facade.get_tasks(@user_id).count).to eq(1)
    response = facade.delete(task.id, @user_id)
    expect(facade.get_tasks(@user_id).count).to eq(0)

    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:message]).to eq("'Water Plants' deleted.")
  end

  it "can fetch an AI breakdown for a task name" do
    facade = TasksFacade.new
    response = facade.get_ai_breakdown("Water Plants")
    expect(response).to have_key(:notes)
    expect(response[:notes]).to be_a(String)
    sad_response = facade.get_ai_breakdown("")
    expect(sad_response[:notes]).to eq("No task provided to breakdown")
  end

  it "can fetch a task by mood" do
    facade = TasksFacade.new
    facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)
    facade.post({"name"=>"Prune Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "frequency"=>"monthly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user_id)
    facade.post({"name"=>"Take Bath",
      "category"=>"rest",
      "mandatory"=>"0",
      "frequency"=>"monthly",
      "notes"=>"Light a candle and have some music and relax!",
      "time_needed"=>60}, @user_id)
    facade.post({"name"=>"Crochet",
      "category"=>"hobby",
      "mandatory"=>"0",
      "frequency"=>"monthly",
      "notes"=>"Light a candle and have some music and relax!",
      "time_needed"=>60}, @user_id)

    by_mood = facade.task_by_mood(@user_id, "good").first
    expect(by_mood).to be_a Task
    expect(by_mood.name).to eq("Water Plants")
  end
end