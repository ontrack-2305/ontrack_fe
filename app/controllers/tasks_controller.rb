class TasksController < ApplicationController 
  # before_action :find_user
  # Or rename this to :validate_session
  
  def index 

  end

  def show
    @task = facade.get_task(params[:id], session[:user_id])
  end

  def new 

  end

  def create
    response = facade.post(task_params, session[:user_id])
    if response.status == 200
      redirect_to new_task_path if params[:create_another]
      redirect_to dashboard_path if params[:commit]
      flash[:notice] = JSON.parse(response.body)["message"]
    elsif response.status == 400
      redirect_to new_task_path 
      flash[:notice] = JSON.parse(response.body)["errors"][0]["detail"]
    end
  end

  def update 
    response = facade.patch(task_params, session[:user_id])
    redirect_to task_path(params[:id])
    flash[:notice] = JSON.parse(response.body)["message"]
    flash[:notice] = JSON.parse(response.body)["errors"][0]["detail"] if response.status == 400
  end

  def destroy
    response = facade.delete(params[:id], session[:user_id])
    redirect_to dashboard_path
    flash[:notice] = JSON.parse(response.body)["message"]
  end

  private 

  def task_params
    hash = params.permit(:name, :category, :mandatory, :event_date, :frequency, :notes, :estimated_time, :id).to_h
    hash[:time_needed] = time_needed
    hash
  end

  def time_needed
    params[:hours].to_i * 60 + params[:minutes].to_i
  end

  def facade 
    @_facade ||= TasksFacade.new
  end
  
  #rename this to validate_session?
  # def find_user
    #begin 
      # @user = User.find(session[:user_id])
    # rescue
      # redirect_to root_path
      # flash[:notice] = "Please log in"
    # end
  # end
end