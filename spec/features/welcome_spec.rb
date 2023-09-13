require "rails_helper"
require "omniauth_module"

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

  it "allows me to register for the app with Google" do
    visit root_path

    click_button "Login With Google"
  end
end