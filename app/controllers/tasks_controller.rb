class TasksController < ApplicationController
  before_action :validate_session

  def index 
    @tasks = facade.get_tasks(session[:user_id])
  end

  def show
    @task = facade.get_task(params[:id], session[:user_id])
  end

  def new
    if params[:add_notes]
      response = facade.get_ai_breakdown(params[:name])
      @task = Task.new(task_params)
      @task.notes = response[:notes] if response[:status] == 200
      flash[:alert] = response[:notes] if response[:status] == 400
    end
  end

  def create
    return redirect_to new_task_path(add_notes: true, params: task_params) if params[:get_ai].present?
    
    response = facade.post(task_params, session[:user_id])
    if response.status == 201
      redirect_to new_task_path if params[:create_another]
      redirect_to dashboard_path if params[:commit]
      flash[:notice] = JSON.parse(response.body)["message"]
    else
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
    hash = params.permit(:name, :category, :mandatory, :event_date, :frequency, :notes, :estimated_time, :id).to_h.symbolize_keys
    hash[:time_needed] = time_needed unless time_needed == 0
    hash
  end

  def time_needed
    params[:hours].to_i * 60 + params[:minutes].to_i
  end

  def facade 
    @_facade ||= TasksFacade.new
  end
end