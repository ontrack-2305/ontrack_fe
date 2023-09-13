class DatabaseService
  def post(attributes_hash)
    connection.post("api/v1/tasks") do |faraday|
      attributes_hash.each do |key, value|
        faraday.params[key] = value
      end
    end
  end

  def get_task(id)
    connection.get("api/v1/tasks/#{id}")
  end

  def connection
    Faraday.new("http://our_render_url.com") # change to render link later
  end
end