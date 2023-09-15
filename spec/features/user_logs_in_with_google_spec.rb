require "rails_helper"

RSpec.describe "The Welcome Page" do
  include OmniauthModule
  before(:each) do
    stub_omniauth
  end
  it "displays the logo/app name and Google login button" do
    visit root_path

    expect(page).to have_content("OnTrack")
    expect(page).to have_button("Login With Google")
    expect("OnTrack").to appear_before("Login With Google")
  end

  it "allows a user to register/login to the app with Google" do
    visit root_path

    expect(page).to have_button("Login With Google")
    click_button "Login With Google"
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, Dani!")
    expect(page).to have_link("Logout")
  end

  it "as a logged in user, I see a welcome and a logout link" do
    visit root_path

    expect(page).to have_button("Login With Google")
    click_button "Login With Google"

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, Dani!")
    expect(page).to have_link("Logout")

    visit root_path

    expect(page).to have_content("Welcome, Dani!")
    expect(page).to have_link("Logout")
    expect(page).to_not have_button("Login With Google")
  end

  it "does not allow invalid credentials to login" do
    stub_invalid_user

    visit root_path

    click_button "Login With Google"

    expect(page).to have_content("Invalid Credentials")
    expect(current_path).to eq(root_path)
  end
end