require 'rails_helper'

RSpec.describe 'User registration form' do
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