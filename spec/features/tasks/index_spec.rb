require "rails_helper"

RSpec.describe "Tasks Index Page" do
  include OmniauthModule  
  before(:each) do
    stub_omniauth
    visit root_path
    click_button "Log In With Google"
    visit tasks_path
  end

  it "has all tasks", :vcr do
    # make some fake tasks first
  end
end