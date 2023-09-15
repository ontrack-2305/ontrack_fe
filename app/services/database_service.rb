class DatabaseService
  def post(attributes_hash, user_id)
    connection.post("api/v1/users/#{user_id}/tasks") do |faraday|
      attributes_hash.each do |key, value|
        faraday.params[key] = value
      end
    end
  end

  def patch(attributes_hash, user_id)
    connection.patch("api/v1/users/#{user_id}/tasks/#{attributes_hash["id"]}") do |faraday|
      attributes_hash.each do |key, value|
        faraday.params[key] = value if key != "id"
      end
    end
  end

  def destroy(task_id, user_id)
    connection.delete("api/v1/users/#{user_id}/tasks/#{task_id}")
  end

  def get_task(task_id, user_id)
    connection.get("api/v1/users/#{user_id}/tasks/#{task_id}")
  end

  def get_tasks(user_id)
    connection.get("api/v1/users/#{user_id}/tasks")
  end

  def connection
    Faraday.new("http://localhost:3000") # change to render link later
  end
end