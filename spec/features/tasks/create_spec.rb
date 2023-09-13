require "rails_helper"

RSpec.describe "Task Create Page" do
  before(:each) do
    # insert helper method to log in a user here when user database exists
    # Mock up a task @task1 = something
    # Mock up a second task @task2 = something
    visit new_task_path
  end

  it "has a form to create a task" do
    expect(page).to have_content("Task name")
    expect(page).to have_field(:name)
    expect(page).to have_content("Task type")
    expect(page).to have_select(:type, with_options: ["", "Rest", "Hobby", "Chore"])
    expect(page).to have_content("Mandatory?")
    expect(page).to have_unchecked_field(:mandatory)
    expect(page).to have_content("Event date")
    expect(page).to have_field(:event_date)
    expect(page).to have_content("Frequency")
    expect(page).to have_select(:frequency, with_options: ["One Time", "Daily", "Weekly", "Monthly"])
    expect(page).to have_content("Expected time needed")
    expect(page).to have_field(:hours)
    expect(page).to have_field(:minutes)
    expect(page).to have_content("Description")
    expect(page).to have_field(:description)
  end

  it "has a button to go to tasks index page" do
    expect(page).to have_button("All tasks")
    click_button("All tasks")
    expect(current_path).to eq(tasks_path)
  end

  it "has a button to go to dashboard" do
    expect(page).to have_button("Dashboard")
    click_button("Dashboard")
    expect(current_path).to eq(dashboard_path)
  end

  it "cannot be accessed if no user is logged in" do
    pending "user sessions created"
    log_out
    visit dashboard_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Please log in") # exact message pending
  end

  it "creates a task for the user who is logged in" do
    json_response = {message: "'Water Plants' added!"}.to_json
    stub_request(:post, "http://our_render_url.com/api/v1/tasks?description=Remember%20plants%20in%20bedroom,%20living%20room,%20and%20balcony&event_date=&frequency=Weekly&mandatory=1&name=Water%20Plants&time_needed=20&type=Chore").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Length'=>'0',
      'User-Agent'=>'Faraday v2.7.11'
      }).
    to_return(status: 200, body: json_response)

    visit tasks_path
    expect(page).to_not have_content("Water Plants")

    visit new_task_path
    fill_in(:name, with: "Water Plants")
    select("Chore", from: :type)
    check(:mandatory)
    select("Weekly", from: :frequency)
    fill_in(:minutes, with: 20)
    fill_in(:description, with: "Remember plants in bedroom, living room, and balcony") #rename description to notes?
    click_button("Save and Back to Dashboard")
    
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("'Water Plants' added!")
    # visit tasks_path   ###Add these back when backend finished
    # expect(page).to have_content("Water Plants")
  end

  it "can refresh page to create another task if 'create and make another' is clicked" do
    json_response = {message: "'Water Plants' added!"}.to_json
    stub_request(:post, "http://our_render_url.com/api/v1/tasks?description=Remember%20plants%20in%20bedroom,%20living%20room,%20and%20balcony&event_date=&frequency=Weekly&mandatory=1&name=Water%20Plants&time_needed=20&type=Chore").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Length'=>'0',
      'User-Agent'=>'Faraday v2.7.11'
      }).
    to_return(status: 200, body: json_response)
    
    visit tasks_path
    expect(page).to_not have_content("Water Plants")

    visit new_task_path
    fill_in(:name, with: "Water Plants")
    select("Chore", from: :type)
    check(:mandatory)
    select("Weekly", from: :frequency)
    fill_in(:minutes, with: 20)
    fill_in(:description, with: "Remember plants in bedroom, living room, and balcony") #rename description to notes?
    click_button("Save and Create Another Task")
    
    expect(current_path).to eq(new_task_path)
    expect(page).to have_content("'Water Plants' added!")

    # visit tasks_path    ### add back in once backend done
    # expect(page).to have_content("Water Plants")
  end

  it "does not create a task if any mandatory fields are missing" do
    json_response = {errors: [{detail: "Validation failed: Name can't be blank, type can't be blank, time needed can't be blank"}]}
    stub_request(:post, "http://our_render_url.com/api/v1/tasks?description=Remember%20plants%20in%20bedroom,%20living%20room,%20and%20balcony&event_date=&frequency=One%20Time&mandatory=0&name=&time_needed=0&type=").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Length'=>'0',
      'User-Agent'=>'Faraday v2.7.11'
      }).
    to_return(status: 200, body: json_response, headers: {})

    expect(page).to have_content("Mandatory fields marked with a *")
    fill_in(:description, with: "Remember plants in bedroom, living room, and balcony")
    click_button("Save and Back to Dashboard")
    expect(page).to have_content("Validation failed: Name can't be blank, type can't be blank, time needed can't be blank")
  end

  xit "can create a task if optional fields are missing" do
    fill_in(:name, with: "Water Plants")
    select("Chore", from: :type)
    fill_in(:minutes, with: 20)
    click_button("Save and Back to Dashboard")
    expect(page).to have_content("'Water Plants' added successfully")
  end

  xit "can add a prerequisite task" do # similar test applicable to show page
    expect(page).to have_content("Task To Be Done First")
    # Use @task1 mockup 
    # expect(page).to have_select(:prerequisite, with_options: [@task1.name, @task2.name])
    # select(@task1.name, from: :prerequisite)
    fill_in(:name, with: "Water Plants")
    select("Chore", from: :type)
    fill_in(:minutes, with: 20)
    click_button("Save and Back To Dashboard")

    # plant_task = (find the task just created)
    # expect(plant_task.prerequisite).to eq(@task1.id)
    # visit task_path(plant_task.id)
    # expect(page).to have_content(@task1.name)
    # expect(page).to have_button("Remove")
    # expect(page).to_not have_select(:prerequisite)
  end

  xit "can generate an AI-powered description" do #similar test applicable to show page
    expect(page).to have_field(:description, value: "")
    fill_in(:name, with: "Water Plants")
    click_button("Generate a Suggested Breakdown of this Task")
    # expect(page).to have_field(:description, with: {String Object?})
  end

  xit "ai generation doesn't work if no name added yet" do # similar test applicable to show page
    click_button("Generate a Suggested Breakdown of this Task")
    expect(page).to have_content("Please input a task name first") # exact message debatable
  end
end