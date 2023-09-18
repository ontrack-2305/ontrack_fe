require "rails_helper"

RSpec.describe "the user dashboard page", :vcr do
  include OmniauthModule

  before(:each) do
    @facade = TasksFacade.new
    stub_user
    stub_omniauth
    visit root_path
    click_button "Log In With Google"

    @facade.post({"name"=>"Take Vitamins",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>"flintstone gummies all dayeee",
      "time_needed"=>5}, @user.id)
    
      @facade.post({"name"=>"Brush Apollo",
      "category"=>"chore",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"he shed",
      "time_needed"=>5}, @user.id)

      @mandatory_task = @facade.get_tasks(@user.id).first
      @non_mandatory_task = @facade.get_tasks(@user.id).last
    end

    after(:each) do
      @facade.delete(@task.id, @user.id)
    end

    it "displays a flash welcome message with the user first name" do
      expect(page).to have_content("Welcome, John!")
    end

    it "prompts me to input my mood" do
      visit dashboard_path

      expect(page).to have_button("Meh")
      expect(page).to have_button("Good")
      expect(page).to have_button("Bad")
    end


  end