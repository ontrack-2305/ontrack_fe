class DatabaseService
  def post(attributes_hash, user_id)
    connection.post("api/v1/users/#{user_id}/tasks") do |faraday|
      attributes_hash.each do |key, value|
        faraday.params[key] = value
      end
    end
  end

  def patch(attributes_hash, user_id)
    connection.patch("api/v1/users/#{user_id}/tasks/#{attributes_hash[:id]}") do |faraday|
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

  def get_tasks(user_id, filters = {})
    connection.get("api/v1/users/#{user_id}/tasks") do |faraday|
      filters.each do |key, value|
        faraday.params[key] = value
      end
    end
  end
  
  def get_ai_breakdown(task_name)
    connection.get("api/v1/chat_service?task=#{task_name.downcase}")
  end

  def connection
    Faraday.new("http://localhost:3000") # change to heroku link later
  end
end