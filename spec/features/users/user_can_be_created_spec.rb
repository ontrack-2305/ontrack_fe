require 'rails_helper'

RSpec.describe 'User registration form' do
  it 'creates a new user' do
    visit root_path

    click_on 'Register with us!'

    expect(current_path).to eq(new_user_path)

    fill_in :first_name, with: 'John'
    fill_in :last_name, with: 'Doe'
    fill_in :email, with: 'John@imjohn.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'password'
    click_button 'Create User'

    expect(current_path).to eq(dashboard_path)
  end
end