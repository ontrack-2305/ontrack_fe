class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    mood = params[:mood]
    @user = User.find_by(params[:google_id])
    @task = TasksFacade.new.task_by_mood(@user.id, mood)
    # does this need to be defined at all if there's already a @_current_user?
  end
end