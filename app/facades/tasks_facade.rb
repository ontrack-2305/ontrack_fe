class TasksFacade 
  def initialize
    @tasks_by_id = {}
  end

  def post(attributes_hash, user_id)
    service.post(attributes_hash, user_id)
  end

  def patch(attributes_hash, user_id)
    @tasks_by_id[attributes_hash["id"]] = nil
    service.patch(attributes_hash, user_id)
  end

  def get_tasks(user_id)
    @task_list ||= fetch_tasks(user_id)
  end

  def get_task(task_id, user_id)
    @tasks_by_id[task_id] ||= fetch_task(task_id, user_id)
  end

  def fetch_task(task_id, user_id)
    response = service.get_task(task_id, user_id)
    parsed = JSON.parse(response.body, symbolize_names: true)
    Task.new(parsed[:data][0])
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