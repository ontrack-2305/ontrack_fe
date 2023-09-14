require "rails_helper"

RSpec.describe "Task Show/Edit Page" do
  before(:each) do
    json_response = File.read("spec/fixtures/mock_one_task.json")
    stub_request(:get, "http://our_render_url.com/api/v1/users//tasks/23").
    with(
      headers: {
     'Accept'=>'*/*',
     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     'User-Agent'=>'Faraday v2.7.11'
      }).
    to_return(status: 200, body: json_response)


    @task = TasksFacade.new.get_task("23", nil)
    visit task_path("23")
  end

  it "has a form with pre-filled current attributes of the task" do
    expect(page).to have_content("Task name")
    expect(page).to have_field(:name, with: @task.name)
    expect(page).to have_content("Task category")
    expect(page).to have_select(:category, with_options: ["", "Rest", "Hobby", "Chore"], selected: @task.category)
    expect(page).to have_content("Mandatory?")
    expect(page).to have_checked_field(:mandatory)
    expect(page).to have_content("Event date")
    expect(page).to have_field(:event_date, with: @task.event_date)
    expect(page).to have_content("Frequency")
    expect(page).to have_select(:frequency, with_options: ["One Time", "Daily", "Weekly", "Monthly", "Annual"], selected: @task.frequency)
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

  it "has a button to go to dashboard" do
    expect(page).to have_button("Dashboard")
    click_button("Dashboard")
    expect(current_path).to eq(dashboard_path)
  end

  xit "cannot be accessed if no user is logged in" do
    pending "user sessions created"
    log_out
    visit dashboard_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Please log in") # exact message pending
  end

  it "can update attributes of task" do
    json_response = {message: "Changes saved!"}.to_json
    stub_request(:patch, "http://our_render_url.com/api/v1/users//tasks/23?event_date=2024-10-27&frequency=One%20Time&mandatory=1&name=thing1&notes=Different%20notes&time_needed=20&category=Hobby").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Length'=>'0',
          'User-Agent'=>'Faraday v2.7.11'
           }).
         to_return(status: 200, body: json_response)

    expect(page).to have_field(:notes, with: "stuff")
    fill_in(:notes, with: "Different notes")
    click_button("Save Changes")
    expect(page).to have_content("Changes saved!")
    expect(current_path).to eq(task_path("23"))

    # visit task_path("23")  ##Add these lines after full functionality working, and can check that task actually updated
    # expect(page).to have_field(:notes, with: "Different notes")

    # Potential: First test that save button is disabled,
    # Then becomes enabled if anything is changed?
    # Not sure how to live update a page without refreshing
    # Through googling it sounds like you need to add JavaScript event listeners
  end

  it "has an error if any mandatory fields are deleted" do
    json_response = {errors: [{detail: "Validation failed: Name can't be blank"}]}.to_json
    stub_request(:patch, "http://our_render_url.com/api/v1/users//tasks/23?event_date=2024-10-27&frequency=One%20Time&mandatory=1&name=&notes=stuff&time_needed=20&category=Hobby").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Length'=>'0',
          'User-Agent'=>'Faraday v2.7.11'
           }).
         to_return(status: 400, body: json_response)

    fill_in(:name, with: "")
    click_button("Save Changes")
    expect(page).to have_content("Validation failed: Name can't be blank")
    expect(current_path).to eq(task_path("23"))
  end

  xit "can delete task" do
    # have message asking user if they are sure yes/no
    # redirect to dashboard after deleting
    # visit index to check it's removed
  end

  xit "can generate an AI breakdown of task if not there already" do

  end

  xit "will replace any current notes if user uses AI generation button" do
    
  end

  xit "throws an error if user changes anything, does NOT click save, and tries to navigate away" do
    # "You have unsaved changes"
    # ask user if they want to confirm leaving page, or stay 
    # might need javascript... nix for MVP?
  end


end