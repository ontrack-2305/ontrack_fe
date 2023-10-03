class UsersController < ApplicationController
  before_action :validate_session, only: [:show]
  
  def show
    @user = current_user
    @holidays = HolidayFacade.upcoming_holidays
    @mood = params[:mood]
    if params[:calendar] == "true"
      @calendar_events = CalendarEventFacade.new.calendar_events(current_user)
    end
    if @mood.present?
      cookies[:mood] = { value: @mood }
    end
    @task = TasksFacade.new.task_by_mood(@user.id, cookies[:mood])   
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to new_user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end