require "rails_helper"

RSpec.describe "The Welcome Page" do
  it "displays the logo/app name and Google login button" do
    visit root_path

    expect(page).to have_content("OnTrack")
    expect(page).to have_button("Login With Google")
    expect("OnTrack").to appear_before("Login With Google")
  end

  it "allows me to register for the app with Google" do
    visit root_path

    click_button "Login With Google"

    expect(current_path).to eq(root_path)
  end
end