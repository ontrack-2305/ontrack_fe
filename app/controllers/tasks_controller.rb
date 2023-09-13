class TasksController < ApplicationController 
  # before_action :find_user
  
  def index 

  end

  def new 

  end

  def create
    response = TasksFacade.new.post(task_params, session[:user_id])
    if response.status == 200
      redirect_to new_task_path if params[:create_another]
      redirect_to dashboard_path if params[:commit]
      flash[:notice] = JSON.parse(response.body)["message"]
    elsif response.status == 400
      redirect_to new_task_path 
      flash[:notice] = JSON.parse(response.body)["errors"][0]["detail"]
      # incorporate ActionCable to stay on page instead of refresh?
    end
  end

  private 

  def task_params
    hash = params.permit(:name, :type, :mandatory, :event_date, :frequency, :notes, :estimated_time).to_h
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