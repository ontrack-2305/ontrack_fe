require "rails_helper"

RSpec.describe "Task Create Page", :vcr do
  include OmniauthModule  
  before(:each) do
    stub_omniauth
    visit root_path
    click_button "Log In With Google"
    visit new_task_path
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
    expect(page).to have_content("Expected time needed")
    expect(page).to have_field(:hours)
    expect(page).to have_field(:minutes)
    expect(page).to have_content("Notes")
    expect(page).to have_field(:notes)
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
    visit root_path
    click_link("Log Out")
    visit dashboard_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Please Log In") # exact message pending
  end

  it "creates a task for the user who is logged in" do
    visit tasks_path
    expect(page).to_not have_content("Water Plants")

    visit new_task_path
    fill_in(:name, with: "Water Plants")
    select(:chore, from: :category)
    check(:mandatory)
    select(:weekly, from: :frequency)
    fill_in(:minutes, with: 20)
    fill_in(:notes, with: "Remember plants in bedroom, living room, and balcony")
    click_button("Save and Back to Dashboard")
    
    expect(current_path).to eq(dashboard_path)
    # expect(page).to have_content("'Water Plants' added!")  #need backend update: success messages
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
    fill_in(:minutes, with: 20)
    fill_in(:notes, with: "Remember plants in bedroom, living room, and balcony")
    click_button("Save and Create Another Task")
    
    expect(current_path).to eq(new_task_path)
    # expect(page).to have_content("'Water Plants' added!")   ##need backend update: success messages

    visit tasks_path
    expect(page).to have_content("Water Plants")
  end

  it "does not create a task if any mandatory fields are missing" do  
    expect(page).to have_content("Mandatory fields marked with a *")
    select(:weekly, from: :frequency)
    fill_in(:notes, with: "Remember plants in bedroom, living room, and balcony")
    click_button("Save and Back to Dashboard")
    expect(current_path).to eq(new_task_path)
    # expect(page).to have_content("Validation failed: Name can't be blank, Category can't be blank, Time needed can't be blank") ##need backend update: error messages in different format
  end

  it "can create a task if optional fields are missing" do
    fill_in(:name, with: "Water Plants")
    select(:chore, from: :category)
    select(:weekly, from: :frequency)
    fill_in(:minutes, with: 20)
    click_button("Save and Back to Dashboard")
    # expect(page).to have_content("'Water Plants' added!")  #need backend update: success messages 
  end

  it "can generate an AI-powered notes" do
    expect(page).to have_field(:notes) # how to test it's empty?
    fill_in(:name, with: "Water Plants")
    click_button("Generate a Suggested Breakdown of this Task")
    expect(page).to have_field(:name, with: "Water Plants")
    expect(page).to have_field(:notes) # how to test it's now got something?
  end

  it "ai generation doesn't work if no name added yet" do # similar test applicable to show page
    click_button("Generate a Suggested Breakdown of this Task (Powered by AI)")
    expect(page).to have_content("No task provided to breakdown")
  end
end