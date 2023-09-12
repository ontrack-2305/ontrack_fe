require "rails_helper"

RSpec.describe "The Welcome Page" do
  it "displays the logo/app name and Google login button" do
    visit root_path

    expect(page).to have_content("OnTrack")
    expect(page).to have_button("Login With Google")
    expect("OnTrack").to appear_before("Login With Google")
  end
end