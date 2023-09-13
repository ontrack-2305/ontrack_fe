class DatabaseService
  def post(attributes_hash, user_id)
    connection.post("api/v1/users/#{user_id}/tasks") do |faraday|
      attributes_hash.each do |key, value|
        faraday.params[key] = value
      end
    end
  end

  def get_task(task_id, user_id)
    connection.get("api/v1/users/#{user_id}/tasks/#{task_id}")
  end

  def get_tasks(user_id)
    connection.get("api/v1/users/#{user_id}/tasks")
  end

  def connection
    Faraday.new("http://our_render_url.com") # change to render link later
  end
end