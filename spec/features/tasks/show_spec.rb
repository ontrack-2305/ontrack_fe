require "rails_helper"

RSpec.describe "Task Show/Edit Page", :vcr do
  include OmniauthModule  

  before(:each) do
    @facade = TasksFacade.new
    stub_user
    stub_omniauth
    visit root_path
    click_button "Log In With Google"

    @facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony"}, @user.id)

    @task = @facade.get_tasks(@user.id).last


    visit task_path(@task.id)
  end

  after(:each) do
    @facade.delete(@task.id, @user.id)
  end

  it "has a form with pre-filled current attributes of the task" do
    expect(page).to have_content("Task name")
    expect(page).to have_field(:name, with: @task.name)
    expect(page).to have_content("Task category")
    expect(page).to have_select(:category, with_options: ["", :rest, :hobby, :chore], selected: @task.category)
    expect(page).to have_content("Mandatory?")
    expect(page).to have_checked_field(:mandatory)
    expect(page).to have_content("Event date")
    expect(page).to have_field(:event_date, with: @task.event_date)
    expect(page).to have_content("Frequency")
    expect(page).to have_select(:frequency, with_options: [:once, :daily, :weekly, :monthly, :annual], selected: @task.frequency)
    expect(page).to have_content("Notes")
    expect(page).to have_field(:notes, with: @task.notes)
  end

  it "cannot be accessed if no user is logged in" do
    visit root_path
    click_on("Log Out")
    visit dashboard_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Please Log In")
  end

  it "can update attributes of task" do
    expect(page).to have_field(:notes, with: @task.notes)
    fill_in(:notes, with: "Different notes")
    click_button("Save Changes")
    expect(page).to have_content("Changes saved!")
    expect(current_path).to eq(task_path(@task.id))

    visit task_path(@task.id)
    expect(page).to have_field(:notes, with: "Different notes")
  end

  it "has an error if any mandatory fields are deleted" do
    fill_in(:name, with: "")
    click_button("Save Changes")
    expect(page).to have_content("Validation failed: Name can't be blank")
    expect(current_path).to eq(task_path(@task.id))
  end

  it "can delete task" do
    visit tasks_path
    expect(page).to have_content("Water Plants")

    visit task_path(@task.id)
    expect(page).to have_button("Delete")
    click_button("Delete")

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("'Water Plants' deleted.")

    visit tasks_path
    expect(page).to_not have_content("Water Plants")
  end

  it "can generate an AI breakdown of task" do
    old_notes = @task.notes
    expect(page).to have_field(:notes, with: old_notes)
    click_button("Generate a Suggested Breakdown\nof this Task (Powered by AI)")
    
    expect(page).to have_field(:name, with: "Water Plants")
    expect(page).to_not have_field(:notes, with: @task.notes)

    click_button("Save Changes")
    updated_task = @facade.get_task(@task.id, @user.id)
    expect(updated_task.notes).to_not eq(old_notes)
  end
end