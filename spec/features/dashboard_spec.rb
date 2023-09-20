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

      @facade.post({"name"=>"Shower",
      "category"=>"chore",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>"",
      "time_needed"=>15}, @user.id)

      @mandatory_task = @facade.get_tasks(@user.id).first
      @non_mandatory_task = @facade.get_tasks(@user.id).second
      @another_mandatory = @facade.get_tasks(@user.id).last
    end

    after(:each) do
      @facade.delete(@mandatory_task.id, @user.id)
      @facade.delete(@non_mandatory_task.id, @user.id)
      @facade.delete(@another_mandatory.id, @user.id)
    end

    it "displays a welcome message with the user first name" do #edit to be a non-persisting flash message only
      expect(page).to have_content("Welcome, John!")
    end

    it "displays a mood button for 'meh', 'good', and 'bad' days" do
      page.has_css?("good_button")
      page.has_css?("meh_button")
      page.has_css?("bad_button")
    end

    xit "when I click on a button, that button stays highlighted" do #can Anna help w/this?
      click_button("happy face button image")
    end

    xit "only gets one task at a time with options" do
      click_button("happy face button image")

      expect(page).to have_content(@mandatory_task.name || @another_mandatory.name)
      expect(page).to have_content("skip")
      expect(page).to have_content("completed")
      expect(page).to have_content("details")
    end

    xit "persists if I leave the page" do
      click_button("happy face button image")

      expect(page).to have_content(@mandatory_task.name || @another_mandatory.name)

      visit new_task_path

      visit dashboard_path
      expect(page).to have_content(@mandatory_task.name || @another_mandatory.name)

      expect()
    end
  end