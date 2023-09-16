require "rails_helper"

RSpec.describe "Tasks Index Page", :vcr do
  include OmniauthModule  
  before(:each) do
    stub_omniauth
    visit root_path
    click_button "Log In With Google"
    
    @user = User.last
    @facade = TasksFacade.new
    generate_tasks_for(@user)
    @tasks = @facade.get_tasks(@user.id)
    
    visit tasks_path
  end

  after(:each) do
    delete_tasks_for(@user)
  end

  it "has all tasks, which link to their show pages" do
    expect(page).to have_link("Water Plants", href: task_path(@tasks[0]))
    expect(page).to have_link("Prune Plants", href: task_path(@tasks[1]))
    expect(page).to have_link("Repot Plants", href: task_path(@tasks[2]))
    expect(page).to have_link("Wash Plants", href: task_path(@tasks[3]))
    expect(page).to have_link("Clean Plants", href: task_path(@tasks[4]))
    expect(page).to have_link("Buy more plants", href: task_path(@tasks[5]))
  end
end