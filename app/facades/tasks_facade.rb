class TasksFacade 
  def post(attributes_hash, user_id)
    service.post(attributes_hash, user_id)
  end

  def patch(attributes_hash, user_id)
    service.patch(attributes_hash, user_id)
  end

  def get_tasks(user_id, filters = {})
    response = service.get_tasks(user_id, filters)
    task_hashes = JSON.parse(response.body, symbolize_names: true)[:data]
    task_hashes.map do |task_hash|
      Task.new(task_hash[:attributes], task_hash[:id])
    end
  end

  def get_task(task_id, user_id)
    response = service.get_task(task_id, user_id)
    parsed = JSON.parse(response.body, symbolize_names: true)
    Task.new(parsed[:data][:attributes], parsed[:data][:id])
  end

  def delete(task_id, user_id)
    service.destroy(task_id, user_id)
  end

  def get_ai_breakdown(task_name)
    response = service.get_ai_breakdown(task_name)
    if response.status == 200
      {notes: JSON.parse(response.body, symbolize_names: true)[:response][0][:text], status: 200 }
    else
      {notes: JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail], status: 400 }
    end
  end

  private

  def service
    @_service ||= DatabaseService.new
  end
end