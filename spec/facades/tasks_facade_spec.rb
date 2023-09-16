require "rails_helper"

RSpec.describe TasksFacade, :vcr do
  xit "can post a task" do    
    facade = TasksFacade.new 
    count = facade.get_tasks("1").count
    response = facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, "1")

    expect(facade.get_tasks("1").count).to eq(count + 1)
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response[:message]).to eq("'Water Plants' added!") ## pending backend update
  end

  it "can fetch all tasks" do
    facade = TasksFacade.new
    facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, "1")
    facade.post({"name"=>"Prune Plants",
        "category"=>"chore",
        "mandatory"=>"1",
        "event_date"=>"",
        "frequency"=>"weekly",
        "notes"=>"Remember plants in bedroom, living room, and balcony",
        "time_needed"=>20}, "1")

    tasks = facade.get_tasks("1")
    expect(tasks).to be_an(Array)
    expect(tasks).to all be_a(Task)
    expect(tasks.count >= 2).to eq(true)
  end

  xit "can update a task" do
    facade = TasksFacade.new
    response = facade.patch({
      "id"=>"1",
      "name"=>"Water Plants",
      "category"=>"Chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"Weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, "1")
    
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:message]).to eq("Changes saved!")  ##pending backend update
  end

  it "can get one task" do
    facade = TasksFacade.new
    facade.post({"name"=>"Repot Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, "1")
    tasks = facade.get_tasks("1")

    task = facade.get_task(tasks.last.id, "1")
    expect(task).to be_a(Task)
    expect(task.name).to eq("Repot Plants")
  end

 xit "can delete a task" do
    facade = TasksFacade.new
    facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, "1")
    tasks = facade.get_tasks("1")
    task = facade.get_task(tasks.first.id, "1")
    task_count = tasks.count
    response = facade.delete(task.id, "1")
    expect(facade.get_tasks("1").count).to eq(task_count - 1)

    parsed = JSON.parse(response.body, symbolize_names: true) ##pending backend update
    expect(parsed[:message]).to eq("'Water Plants' deleted.") # pending backend update
  end

  it "can fetch an AI breakdown for a task name" do
    facade = TasksFacade.new
    response = facade.get_ai_breakdown("Water Plants")
    expect(response).to have_key(:notes)
    expect(response[:notes]).to be_a(String)
    sad_response = facade.get_ai_breakdown("")
    expect(sad_response[:notes]).to eq("No task provided to breakdown")
  end
end