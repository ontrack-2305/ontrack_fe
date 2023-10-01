require "rails_helper"

RSpec.describe "Task Create Page", :vcr do
  include OmniauthModule  
  before(:each) do
    stub_user
    stub_omniauth
    visit root_path
    click_button "Log In With Google"
    visit new_task_path
  end

  after(:each) do
    facade = TasksFacade.new
    begin
      tasks = facade.get_tasks("123")
    rescue
      tasks = []
    end
    tasks.each do |task|
      facade.delete(task.id, "123")
    end
  end

  it "has a form to create a task" do
    expect(page).to have_content("Task name")
    expect(page).to have_field(:name)
    expect(page).to have_content("Task category")
    expect(page).to have_select(:category, with_options: ["", :rest, :hobby, :chore])
    expect(page).to have_content("Mandatory?")
    expect(page).to have_unchecked_field(:mandatory)
    expect(page).to have_content("Event date")
    expect(page).to have_field(:event_date)
    expect(page).to have_content("Frequency")
    expect(page).to have_select(:frequency, with_options: [:once, :daily, :weekly, :monthly, :annual])
    expect(page).to have_content("Notes")
    expect(page).to have_field(:notes)
    expect(page).to have_field(:image_data)
  end

  it "cannot be accessed if no user is logged in" do
    visit root_path
    click_link("Log Out")
    visit dashboard_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Please Log In")
  end

  it "creates a task for the user who is logged in" do
    visit tasks_path
    expect(page).to_not have_content("Water Plants")

    visit new_task_path
    fill_in(:name, with: "Water Plants")
    select(:chore, from: :category)
    check(:mandatory)
    select(:weekly, from: :frequency)
    fill_in(:notes, with: "Remember plants in bedroom, living room, and balcony")
    click_button("Save and Back to Dashboard")
    
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("'Water Plants' added!") 
    visit tasks_path
    expect(page).to have_content("Water Plants")
  end

  it "can refresh page to create another task if 'create and make another' is clicked" do
    visit tasks_path
    expect(page).to_not have_content("Water Plants")

    visit new_task_path
    fill_in(:name, with: "Water Plants")
    select(:chore, from: :category)
    check(:mandatory)
    select(:weekly, from: :frequency)
    fill_in(:notes, with: "Remember plants in bedroom, living room, and balcony")
    click_button("Save and Create Another Task")
    
    expect(current_path).to eq(new_task_path)
    expect(page).to have_content("'Water Plants' added!")

    visit tasks_path
    expect(page).to have_content("Water Plants")
  end

  it "does not create a task if any mandatory fields are missing" do 
    expect(page).to have_content("Mandatory fields marked with a *")
    select(:weekly, from: :frequency)
    fill_in(:notes, with: "Remember plants in bedroom, living room, and balcony")
    click_button("Save and Back to Dashboard")
    expect(current_path).to eq(new_task_path)
    expect(page).to have_content("Validation failed: Name can't be blank, Category can't be blank")
  end

  it "keeps user's progress even if there is an error when creating a task" do
    fill_in(:name, with: "do taxes")
    fill_in(:event_date, with: "2024-04-04")
    select(:annual, from: :frequency)
    check(:mandatory)
    fill_in(:notes, with: "Some random notes")
    click_button("Save and Back to Dashboard")

    expect(current_path).to eq(new_task_path)
    expect(page).to have_content("Validation failed: Category can't be blank")
    expect(page).to have_field(:name, with: "do taxes")
    expect(page).to have_field(:event_date, with: "2024-04-04")
    expect(page).to have_select(:frequency, selected: "annual")
    expect(page).to have_checked_field(:mandatory)
    expect(page).to have_field(:notes, with: "Some random notes")
  end

  it "can create a task if optional fields are missing" do
    fill_in(:name, with: "Water Plants")
    select(:chore, from: :category)
    select(:weekly, from: :frequency)
    click_button("Save and Back to Dashboard")
    expect(page).to have_content("'Water Plants' added!") 
  end

  it "can generate AI-powered notes" do
    expect(page).to have_field(:notes) do |field|
      expect(field.value).to eq("")
    end

    fill_in(:name, with: "Water Plants")
    click_button("Generate a Suggested Breakdown\nof this Task (Powered by AI)")
    expect(page).to have_field(:name, with: "Water Plants")
  
    expect(page).to have_field(:notes) do |field|
      expect(field.value).to_not be_empty
    end
  end

  it "ai generation doesn't work if no name added yet" do
    click_button("Generate a Suggested Breakdown\nof this Task (Powered by AI)")
    expect(page).to have_content("No task provided to breakdown")
  end
end