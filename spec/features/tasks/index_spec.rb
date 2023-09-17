require "rails_helper"

RSpec.describe "Tasks Index Page", :vcr do
  include OmniauthModule  
  before(:each) do
    stub_user
    stub_omniauth
    visit root_path
    click_button "Log In With Google"
    
    @facade = TasksFacade.new
    generate_tasks_for(@user)
    @tasks = @facade.get_tasks(@user.id)
    
    visit tasks_path
  end

  after(:each) do
    delete_tasks_for(@user)
  end

  it "has all tasks, which link to their show pages" do
    expect(page).to have_link("Water Plants", href: task_path(@tasks[0].id))
    expect(page).to have_link("Clean fish tank", href: task_path(@tasks[1].id))
    expect(page).to have_link("Take nice bath", href: task_path(@tasks[2].id))
    expect(page).to have_link("Meditate", href: task_path(@tasks[3].id))
    expect(page).to have_link("Practice guitar", href: task_path(@tasks[4].id))
    expect(page).to have_link("Practice drawing", href: task_path(@tasks[5].id))
  end

  it "can filter tasks by frequency" do
    pending "BE index endpoint updated to take search queries"
    expect(page).to have_select(:frequency, with_options: ["Select Frequency", :once, :daily, :weekly, :monthly, :annual])
    select(:daily, from: :frequency)
    click_button("Filter Tasks")

    expect(page).to_not have_content("Water Plants")
    expect(page).to_not have_content("Clean fish tank")
    expect(page).to_not have_content("Take nice bath")

    expect(page).to have_content("Meditate")
    expect(page).to have_content("Practice guitar")
    expect(page).to have_content("Practice drawing")
  end

  it "can filter tasks by mandatory status" do
    pending "BE index endpoint updated to take search queries"
    expect(page).to have_select(:mandatory, with_options: ["Select Priority", :mandatory, :optional])
    select(:mandatory, from: :mandatory)
    click_button("Filter Tasks")

    expect(page).to have_content("Water Plants")
    expect(page).to have_content("Clean fish tank")

    expect(page).to_not have_content("Take nice bath")
    expect(page).to_not have_content("Meditate")
    expect(page).to_not have_content("Practice guitar")
    expect(page).to_not have_content("Practice drawing")
  end

  it "can filter tasks by category" do
    pending "BE index endpoint updated to take search queries"
    expect(page).to have_select(:category, with_options: ["Select Category", :rest, :hobby, :chore])
    select(:rest, from: :category)
    click_button("Filter Tasks")

    expect(page).to have_content("Take nice bath")
    expect(page).to have_content("Meditate")
    
    expect(page).to_not have_content("Water Plants")
    expect(page).to_not have_content("Clean fish tank")
    expect(page).to_not have_content("Practice guitar")
    expect(page).to_not have_content("Practice drawing")
  end

  it "can filter by all categories at once" do
    pending "BE index endpoint updated to take search queries"
    select(:daily, from: :frequency)
    select(:rest, from: :category)
    select(:optional, from: :mandatory)
    click_button("Filter Tasks")

    expect(page).to have_content("Meditate")

    expect(page).to_not have_content("Take nice bath")    
    expect(page).to_not have_content("Water Plants")
    expect(page).to_not have_content("Clean fish tank")
    expect(page).to_not have_content("Practice guitar")
    expect(page).to_not have_content("Practice drawing")
  end

  it "can reset/clear filters" do
    pending "BE index endpoint updated to take search queries"
    select(:daily, from: :frequency)
    select(:rest, from: :category)
    select(:optional, from: :mandatory)
    click_button("Filter Tasks")
    
    expect(page).to have_select(:frequency, selected: :daily)
    expect(page).to have_select(:mandatory, selected: :optional)
    expect(page).to have_select(:category, selected: :rest)

    expect(page).to have_button("Clear Filters")
    click_button("Clear Filters")

    expect(page).to have_content("Water Plants")
    expect(page).to have_content("Clean fish tank")
    expect(page).to have_content("Take nice bath")
    expect(page).to have_content("Meditate")
    expect(page).to have_content("Practice guitar")
    expect(page).to have_content("Practice drawing")
  end
end