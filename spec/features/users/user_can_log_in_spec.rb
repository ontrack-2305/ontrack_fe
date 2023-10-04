require 'rails_helper'

RSpec.describe "Logging in" do
  describe "Happy Path" do
    it "logs in a user", :vcr do
      user1 = User.create!(email: "Jbob@somewhere.com", password: 'password123', password_confirmation: 'password123')

      visit root_path

      fill_in :email, with: 'Jbob@somewhere.com'
      fill_in :password, with: 'password123'

      click_button 'Log In'

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("Welcome, #{user1.email}")
    end
  end
end