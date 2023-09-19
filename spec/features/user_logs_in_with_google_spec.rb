require "rails_helper"

RSpec.describe "The Welcome Page", :vcr do
  include OmniauthModule
  before(:each) do
    stub_omniauth
  end

  it "displays the logo/app name and Google login button" do
    visit root_path

    expect(page).to have_content("OnTrack")
    expect(page).to have_button("Log In With Google")
    expect("OnTrack").to appear_before("Log In With Google")
  end

  it "allows a user to register/log in to the app with Google" do
    visit root_path

    expect(page).to have_button("Log In With Google")
    click_button "Log In With Google"
    expect(current_path).to eq(dashboard_path)
    # expect(page).to have_content("Welcome, Dani!")
    expect(page).to have_link("Log Out")
  end

  it "does not allow invalid credentials to log in" do
    stub_invalid_user

    visit root_path

    click_button "Log In With Google"

    expect(page).to have_content("Invalid Credentials")
    expect(current_path).to eq(root_path)
  end
end