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
    
      @facade.post({"name"=>"crochet",
      "category"=>"hobby",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"weekly",
      "notes"=>"granny squares",
      "time_needed"=>60}, @user.id)

      @facade.post({"name"=>"read a book",
      "category"=>"rest",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>"smut",
      "time_needed"=>45}, @user.id)

      @mandatory_chore_task = @facade.get_tasks(@user.id).first
      @non_mandatory_hobby = @facade.get_tasks(@user.id).second
      @non_mandatory_rest = @facade.get_tasks(@user.id).third
    end

    after(:each) do
      @facade.delete(@mandatory_chore_task.id, @user.id)
      @facade.delete(@non_mandatory_hobby.id, @user.id)
      @facade.delete(@non_mandatory_rest.id, @user.id)
    end

    xit "displays a welcome message with the user first name" do #edit to be a non-persisting flash message only
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

    it "only gets one task at a time with options" do
      click_button("happy face button image")

      expect(page).to have_content(@mandatory_chore_task.name)
      expect(page).to have_button("skip")
      expect(page).to have_button("completed")
    end

    it "the mood and task persist if I leave the page" do
      click_button("happy face button image")

      expect(page).to have_content(@mandatory_chore_task.name)

      visit new_task_path

      visit dashboard_path
      
      expect(page).to have_content(@mandatory_chore_task.name)
      expect(page).to_not have_content("Please add a task!")
    end

    it "it will fetch only mandatory tasks if a bad day" do
      click_button("sad face button image")

      expect(page).to have_content(@mandatory_chore_task.name)
    end
  end