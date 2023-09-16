require "rails_helper"

RSpec.describe "Task Show/Edit Page", :vcr do
  include OmniauthModule  

  before(:each) do
    @facade = TasksFacade.new
    stub_omniauth
    visit root_path
    click_button "Log In With Google"

    @user = User.last

    @facade.post({"name"=>"Water Plants",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"Remember plants in bedroom, living room, and balcony",
      "time_needed"=>20}, @user.id)

    @task = @facade.get_tasks(@user.id).last


    visit task_path(@task.id)
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
    expect(page).to have_content("Expected time needed")
    expect(page).to have_field(:hours, with: @task.hours)
    expect(page).to have_field(:minutes, with: @task.minutes)
    expect(page).to have_content("Notes")
    expect(page).to have_field(:notes, with: @task.notes)
  end

  it "has a button to go to tasks index page" do
    expect(page).to have_button("All tasks")
    click_button("All tasks")
    expect(current_path).to eq(tasks_path)
  end

  xit "has a button to go to dashboard" do
    expect(page).to have_button("Dashboard")
    click_button("Dashboard")
    expect(current_path).to eq(dashboard_path)
  end

  it "cannot be accessed if no user is logged in" do
    visit root_path
    click_on("Log Out")
    visit dashboard_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Please Log In")
  end

  xit "can update attributes of task" do
    expect(page).to have_field(:notes, with: @task.notes)
    fill_in(:notes, with: "Different notes")
    click_button("Save Changes")
    expect(page).to have_content("Changes saved!") #pending backend update
    expect(current_path).to eq(task_path(@task.id))

    visit task_path(@task.id)
    expect(page).to have_field(:notes, with: "Different notes")
  end

  xit "has an error if any mandatory fields are deleted" do
    fill_in(:name, with: "")
    click_button("Save Changes")
    expect(page).to have_content("Validation failed: Name can't be blank") ##pending update from backend, reformat errors
    expect(current_path).to eq(task_path(@task.id))
  end

  xit "can delete task" do
    json_response = {message: "'thing1' deleted"}.to_json
    stub_request(:delete, "http://our_render_url.com/api/v1/users//tasks/23").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v2.7.11'
      }).
    to_return(status: 200, body: json_response)

    visit tasks_path
    expect(page).to have_content("Water Plants")

    visit task_path(@task.id)
    expect(page).to have_button("Delete")
    click_button("Delete")
    # expect confirmation message?
    # click "yes" on confirmation message
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("'Water Plants' deleted.")  ##pending update from backend

    visit tasks_path
    expect(page).to_not have_content("Water Plants")
  end

  xit "won't delete task if user selects 'cancel' from confirmation" do
    expect(page).to have_button("Delete")
    click_button("Delete")
    # expect confirmation message?
    # click "cancel" on confirmation message
    expect(current_path).to eq(task_path(@task.id))
  end

  it "can generate an AI breakdown of task" do
    old_notes = @task.notes
    expect(page).to have_field(:notes, with: old_notes)
    click_button("Generate a Suggested Breakdown of this Task (Powered by AI)")
    
    expect(page).to have_field(:name, with: "Water Plants")
    expect(page).to_not have_field(:notes, with: @task.notes)

    click_button("Save Changes")
    updated_task = @facade.get_task(@task.id, @user.id)
    expect(updated_task.notes).to_not eq(old_notes)
  end
end