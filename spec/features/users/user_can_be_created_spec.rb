require 'rails_helper'

RSpec.describe 'User registration form' do
  describe 'Happy Path' do
    it 'creates a new user', :vcr do
      visit root_path
      
      click_on 'Create an Account'
      
      expect(current_path).to eq(new_user_path)
      
      fill_in :user_first_name, with: 'John'
      fill_in :user_last_name, with: 'Doe'
      fill_in :user_email, with: 'John@imjohn.com'
      fill_in :user_password, with: 'password'
      fill_in :user_password_confirmation, with: 'password'
      click_button 'Create Account'
      
      expect(current_path).to eq(dashboard_path)
    end
  end

  describe 'Sad Path' do
    it 'does not create a new user if passwords do not match', :vcr do
      visit root_path
      
      click_on 'Create an Account'
      
      expect(current_path).to eq(new_user_path)
      
      fill_in :user_first_name, with: 'John'
      fill_in :user_last_name, with: 'Doe'
      fill_in :user_email, with: 'jimo@doe.com'
      fill_in :user_password, with: 'password'
      fill_in :user_password_confirmation, with: 'PasSwoRd'
      click_button 'Create Account'

      expect(current_path).to eq(new_user_path)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end