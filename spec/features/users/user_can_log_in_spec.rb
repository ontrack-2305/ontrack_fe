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

  describe "Sad Path" do
    it "does not log in a user if password is incorrect", :vcr do
      user1 = User.create!(email: "Jbob@somewhere.com", password: 'password123', password_confirmation: 'password123')
      
      visit root_path
      fill_in :email, with: 'Jbob@somewhere.com'
      fill_in :password, with: 'PaSsWord123'
      click_button 'Log In'
      
      expect(current_path).to eq(root_path)
      expect(page).to have_content("Sorry, your credentials are bad.")
    end
    
    it "does not log in a user if email is incorrect", :vcr do
      user1 = User.create!(email: "Jbob@somewhere.com", password: 'password123', password_confirmation: 'password123')

      visit root_path
      fill_in :email, with: 'blahblah@coolplace.com'
      fill_in :password, with: 'password123'
      click_button 'Log In'

      expect(current_path).to eq(root_path)
      expect(page).to have_content("Sorry, your credentials are bad.")
    end

    it "does not log in without a password", :vcr do
      user1 = User.create!(email: "Jbob@somewhere.com", password: 'password123', password_confirmation: 'password123')

      visit root_path
      fill_in :email, with: 'Jbob@somewhere.com'
      fill_in :password, with: ''
      click_button 'Log In'

      expect(current_path).to eq(root_path)
      expect(page).to have_content("Sorry, your credentials are bad.")
    end
  end
end