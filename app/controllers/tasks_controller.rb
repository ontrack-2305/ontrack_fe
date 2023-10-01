class TasksController < ApplicationController
  before_action :validate_session

  def index
    @filters = {}
    @filters = filter_params if params[:filter]
    @tasks = facade.get_tasks(session[:user_id], filter_hash)
  end

  def show
    @task = facade.get_task(params[:id], session[:user_id])
    if params[:add_notes] || flash[:notice]&.include?("failed")
      @task = Task.new(task_params, params[:id])
      fetch_notes if params[:add_notes]
    end
  end

  def new
    @task = Task.new(task_params)
    fetch_notes if params[:add_notes]
  end

  def create
    new_params = task_params

    if params[:image_data]
      file = bucket.object(params[:image_data].original_filename)
      file.upload_file(params[:image_data])
      file_url = file.public_url
      new_params = task_params.merge(image_url: file_url)
    end

    return redirect_to new_task_path(add_notes: true, params: new_params) if params[:get_ai].present?

    response = facade.post(new_params, session[:user_id])
    if response.status == 201
      redirect_to new_task_path if params[:create_another]
      redirect_to dashboard_path if params[:commit]
      flash[:notice] = JSON.parse(response.body)["message"]
    else
      redirect_to new_task_path(params: new_params)
      flash[:notice] = JSON.parse(response.body)["errors"][0]["detail"]
    end
  end

  def update
    if params[:skipped] == "true" || params[:completed] == "true"
      facade.patch(task_params, session[:user_id])
      redirect_to dashboard_path and return 
    else
      new_params = task_params
      
      if params[:image_data]
        file = bucket.object(params[:image_data].original_filename)
        file.upload_file(params[:image_data])
        file_url = file.public_url
        new_params = task_params.merge(image_url: file_url)
      end

      return redirect_to task_path(add_notes: true, params: new_params) if params[:get_ai].present?
      response = facade.patch(new_params, session[:user_id])
    
      redirect_to task_path(params: new_params)
      flash[:notice] = JSON.parse(response.body)["message"]
      flash[:notice] = JSON.parse(response.body)["errors"][0]["detail"] if response.status == 400
    end
  end

  def destroy
    response = facade.delete(params[:id], session[:user_id])
    flash[:notice] = JSON.parse(response.body)["message"]
    redirect_to dashboard_path
  end

  private 

  def bucket
    access_key = ENV['AWS_ACCESS_KEY'] || Rails.application.credentials.aws[:ACCESS_KEY]
    secret_access_key = ENV['AWS_SECRET_ACCESS_KEY'] || Rails.application.credentials.aws[:SECRET_ACCESS_KEY]
    
    Aws.config.update(access_key_id: access_key, secret_access_key: secret_access_key)
    Aws::S3::Resource.new(region: "us-west-1", endpoint: "https://s3.us-west-1.amazonaws.com").bucket("ontrack2305")
  end

  def task_params
    hash = params.permit(:name, :category, :mandatory, :event_date, :frequency, :notes, :estimated_time, :id, :time_needed, :skipped, :completed, :image_url).to_h.symbolize_keys
    hash[:time_needed] = time_needed unless time_needed == 0
    hash
  end

  def time_needed
    params[:hours].to_i * 60 + params[:minutes].to_i
  end

  def filter_params
    params.permit(:frequency, :mandatory, :category)
  end

  def fetch_notes
    response = facade.get_ai_breakdown(params[:name])
    @task.notes = response[:notes] if response[:status] == 200
    flash.now[:alert] = response[:notes] if response[:status] == 400
  end

  def filter_hash
    return {} unless !filter_params.empty?
    hash = filter_params.to_h
    hash[:mandatory] = modify_value(hash[:mandatory]) if !hash[:mandatory].include?("Select")
    hash.each { |key, value| value.include?("Select") ? hash.delete(key) : hash[key] }
  end

  def modify_value(value)
    if value == "mandatory"
      "true"
    elsif value == "optional"
      "false"
    end
  end

  def facade 
    @_facade ||= TasksFacade.new
  end
end