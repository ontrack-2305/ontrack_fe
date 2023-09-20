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

      @facade.post({"name"=>"go on a walk",
      "category"=>"rest",
      "mandatory"=>"1",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>"",
      "time_needed"=>30}, @user.id)

      @facade.post({"name"=>"practice juggling",
      "category"=>"hobby",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"monthly",
      "notes"=>"bowling balls, bowling pins",
      "time_needed"=>15}, @user.id)

      @facade.post({"name"=>"do the dishes",
      "category"=>"chore",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>"",
      "time_needed"=>15}, @user.id)

      tasks = @facade.get_tasks(@user.id)

      @vitamins = tasks.first
      @crochet = tasks.second
      @reading = tasks.third
      @walk = tasks.fourth
      @juggling = tasks.fifth
      @dishes = tasks.last
    end

    after(:each) do
      @facade.delete(@vitamins.id, @user.id)
      @facade.delete(@crochet.id, @user.id)
      @facade.delete(@reading.id, @user.id)
      @facade.delete(@walk.id, @user.id)
      @facade.delete(@juggling.id, @user.id)
      @facade.delete(@dishes.id, @user.id)
    end

    it "displays a mood button for 'meh', 'good', and 'bad' days" do
      page.has_css?("good_button")
      page.has_css?("meh_button")
      page.has_css?("bad_button")
    end

    it "only gets one task at a time with options" do
      click_button("happy face button image")

      expect(page).to have_content(@vitamins.name)
      expect(page).to have_button("skip")
      expect(page).to have_button("completed")
    end

    it "the mood and task persist if I leave the page" do
      click_button("happy face button image")

      expect(page).to have_content(@vitamins.name)

      visit new_task_path

      visit dashboard_path
      
      expect(page).to have_content(@vitamins.name)
      expect(page).to_not have_content("Please add a task!")
    end

    it "can display a warning flash message if skipping a mandatory task" do
      pending "warning flash message implemented, skip functionality implemented"
      click_button("happy face button image")

      expect(page).to have_content(@vitamins.name)
      expect(page).to have_button("skip")
      click_button("skip")
      expect(page).to have_content("Are you sure you'd like to skip a mandatory task?")
    end

    xit "can move on to a new task" do
      # extra: get_task from database and check that "completed" is empty

      #visit page with a task on it
      # click completed
      # check that the page refreshes with a new task

      # extra: get_task from database again and check that "completed" exists
      # Can check that completed == stringified Date.today
    end
    
    it "displays a list of upcoming holidays" do
      within("#holidays") do
        expect(page).to have_content("Upcoming Holidays")
        expect(page).to have_content("Columbus Day")
        expect(page).to have_content("Veterans Day")
        expect(page).to have_content("Thanksgiving Day")
      end
    end

    xit "displays a list of upcoming calendar events" do
      click_link('Integrate Google Calendar')
      within("#calendar") do
        expect(page).to have_content("Upcoming Events")
        expect(page).to have_content("TEST EVENT 1")
        expect(page).to have_content("TEST EVENT 2")
      end
    end
end