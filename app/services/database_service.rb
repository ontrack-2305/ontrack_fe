class DatabaseService
  def get_calendar_events(user)
    response = connection.get do |req|
      req.url "api/v1/users/#{user.id}/calendar_events"  
      req.headers['Content-Type'] = 'application/json'
      req.body = { 
        access_token: user.token, 
        user_id: user.id, 
        google_id: user.google_id,
        email: user.email
      }.to_json
    end
  end

  def get_holidays
    response = connection.get("/api/v1/holidays")
    JSON.parse(response.body, symbolize_names: true)
  end
  

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
    Faraday.new("http://localhost:3000/")
  end
end