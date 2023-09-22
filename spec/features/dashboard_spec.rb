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
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"daily",
      "notes"=>"",
      "time_needed"=>30}, @user.id)

      @facade.post({"name"=>"try macrame",
      "category"=>"hobby",
      "mandatory"=>"0",
      "event_date"=>"",
      "frequency"=>"once",
      "notes"=>"",
      "time_needed"=>40}, @user.id)

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
      @macrame = tasks.fifth
      @dishes = tasks.last
    end

    after(:each) do
      tasks = @facade.get_tasks(@user.id)
      tasks.each do |task|
        @facade.delete(task.id, @user.id)
      end
    end

    it "displays a mood button for 'meh', 'good', and 'bad' days" do
      page.has_css?("good_button")
      page.has_css?("meh_button")
      page.has_css?("bad_button")
    end

    it "only gets one task at a time with options" do
      click_button("happy face button image")

      expect(page).to have_content("Take Vitamins")
      expect(page).to have_button("skip")
      expect(page).to have_button("completed")
    end

    it "the mood and task persist if I leave the page" do
      click_button("happy face button image")

      expect(page).to have_content("Take Vitamins")

      visit new_task_path

      visit dashboard_path
      
      expect(page).to have_content("Take Vitamins")
      expect(page).to_not have_content("Please add a task!")
    end

    it "can display a warning flash message if skipping a mandatory task" do
      pending "warning flash message implemented, skip functionality implemented"
      click_button("happy face button image")

      expect(page).to have_content("Take Vitamins")
      expect(page).to have_button("skip")
      click_button("skip")
      expect(page).to have_content("Are you sure you'd like to skip a mandatory task?")
    end

    it "can move on to a new task when skipped" do
      click_button("happy face button image")

      expect(page).to have_content("Take Vitamins")
      expect(page).to have_button("skip")
      click_button("skip")
      expect(page).to have_content("do the dishes")
      expect(page).to_not have_content("Take Vitamins")
    end

    it "can mark a task as complete" do
      click_button("happy face button image")
      
      expect(page).to have_content("Take Vitamins")
      expect(page).to have_button("completed")
      click_button("completed")
      expect(page).to_not have_content("Take Vitamins")
      expect(page).to have_content("do the dishes")
    end

    it "will remove a completed task from the database with a frequency of 'once'" do
      click_button("meh face button image")

      expect(page).to have_content("Take Vitamins")
      click_button("completed")
      expect(page).to_not have_content("Take Vitamins")
      expect(page).to have_content("crochet")
      click_button("completed")
      expect(page).to have_content("macrame")
      click_button("completed")
      expect(page).to have_content("'try macrame' deleted.")
      expect(page).to_not have_content(@macrame)
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