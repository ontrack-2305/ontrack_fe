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
      faraday.params[:search_params] = filters
    end
  end

  def get_daily_tasks(user_id, mood)
    connection.get("api/v1/users/#{user_id}/daily_tasks/") do |faraday|
      faraday.params["mood"] = mood
    end 
  end
  
  def get_ai_breakdown(task_name)
    connection.get("api/v1/chat_service?task=#{task_name.downcase}")
  end

  def connection
    Faraday.new("https://ontrack-be-a58c9e421d34.herokuapp.com/")
  end
end