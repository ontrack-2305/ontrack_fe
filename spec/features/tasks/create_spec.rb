require "rails_helper"

RSpec.describe "Task Create Page" do
  before(:each) do
    # insert helper method to log in a user here when user database exists
    # Mock up a task @task1 = something
    # Mock up a second task @task2 = something
    visit new_task_path
  end

  it "has a form to create a task" do
    expect(page).to have_content("Task Name")
    expect(page).to have_field(:name)
    expect(page).to have_content("Task Type")
    expect(page).to have_select(:type, with: ["Rest", "Hobby", "Chore"])
    expect(page).to have_content("Mandatory?")
    expect(page).to have_checkbox(:mandatory)
    expect(page).to have_content("Event Date")
    expect(page).to have_field(:event_date)
    expect(page).to have_content("Frequency")
    expect(page).to have_select(:frequency, with: ["Daily", "Weekly", "Monthly"])
    expect(page).to have_content("Expected Time Needed")
    expect(page).to have_field(:hours)
    expect(page).to have_field(:minutes)
    expect(page).to have_content("Description")
    expect(page).to have_field(:description)
  end

  xit "has a button to go to tasks index page" do
    expect(page).to have_button("All Tasks")
    click_button("All Tasks")
    expect(current_path).to eq(tasks_path)
  end

  xit "has a button to go to dashboard" do
    expect(page).to have_button("Dashboard")
    click_button("Dashboard")
    expect(current_path).to eq(dashboard_path)
  end

  xit "cannot be accessed if no user is logged in" do
    pending "user log in starts a session"
    log_out
    visit dashboard_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Please log in") # exact message pending
  end

  xit "creates a task for the user who is logged in" do
    visit tasks_path
    expect(page).to_not have_content("Water Plants")

    visit new_task_path
    fill_in(:name, with: "Water Plants")
    select("Chore", from: :type)
    check(:mandatory)
    select("Weekly", from: :frequency)
    fill_in(:minutes, with: 20)
    fill_in(:description, with: "Remember plants in bedroom, living room, and balcony") #rename description to notes?
    click_button("Save and Back To Dashboard")
    
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("'Water Plants' added successfully")
    visit tasks_path
    expect(page).to have_content("Water Plants")
  end

  xit "can refresh page to create another task if 'create and make another' is clicked" do
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
    expect(page).to have_content("'Water Plants' added successfully")

    visit tasks_path
    expect(page).to have_content("Water Plants")
  end

  xit "does not create a task if any mandatory fields are missing" do
    expect(page).to have_content("Mandatory fields marked with a *")
    fill_in(:description, with: "Remember plants in bedroom, living room, and balcony")
    click_button("Save and Back To Dashboard")
    expect(page).to have_content("Error: Name cannot be blank, type cannot be blank, time estimate cannot be blank")
  end

  xit "can create a task if optional fields are missing" do
    fill_in(:name, with: "Water Plants")
    select("Chore", from: :type)
    fill_in(:minutes, with: 20)
    click_button("Save and Back To Dashboard")
    expect(page).to have_content("'Water Plants' added successfully")
  end

  xit "can add a prerequisite task" do # similar test applicable to show page
    expect(page).to have_content("Task To Be Done First")
    # Use @task1 mockup 
    # expect(page).to have_select(:prerequisite, with: [@task1.name, @task2.name])
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