class TasksController < ApplicationController 
  # before_action :find_user
  # before_action :convert_time_needed, only: [:create]
  
  def index 

  end

  def new 

  end

  def create
    response = DatabaseService.new.post(task_params) #pass in user_id
    # Refactor to facade later
    redirect_to new_task_path if params[:create_another]
    redirect_to dashboard_path if params[:commit]
    flash[:notice] = JSON.parse(response.body)["message"]
  end

  private 

  def task_params
    hash = params.permit(:name, :type, :mandatory, :event_date, :frequency, :description, :estimated_time, :prerequisite).to_h
    hash[:time_needed] = time_needed
    hash
  end

  def time_needed
    params[:hours].to_i * 60 + params[:minutes].to_i
  end
  
  # def find_user
    #begin 
      # @user = User.find(session[:user_id])
    # rescue
      # redirect_to root_path
      # flash[:notice] = "Please log in"
    # end
  # end
end