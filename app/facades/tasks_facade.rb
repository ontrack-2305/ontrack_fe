class TasksFacade 

  def post(attributes_hash, user_id)
    service.post(attributes_hash, user_id)
  end

  def get_tasks(user_id)
    @_tasks ||= fetch_tasks(user_id)
  end

  def fetch_tasks(user_id)
    response = service.get_tasks(user_id)
    task_hashes = JSON.parse(response.body, symbolize_names: true)[:data]
    task_hashes.map do |task_hash|
      Task.new(task_hash)
    end
  end

  def service
    @_service ||= DatabaseService.new
  end
end