class HolidayService

  def self.get_holidays
    get_url("/api/v1/holidays")
  end


  def self.conn
    Faraday.new("http://localhost:3000") ## change to heroku link later
  end

  private

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end