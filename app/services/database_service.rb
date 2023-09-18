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

  def authenticate(user)
    response = connection.post do |req|
      req.url '/api/v1/users/authenticate'  
      req.headers['Content-Type'] = 'application/json'
      req.body = { 
        access_token: user.token, 
        user_id: user.id, 
        google_id: user.google_id,
        email: user.email
      }.to_json
    end
  end


  def connection
    Faraday.new("http://localhost:3000") # change to heroku link later
  end
end