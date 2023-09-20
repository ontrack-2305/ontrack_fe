class Task
  attr_reader :id,
              :name,
              :category,
              :event_date,
              :time_needed,
              :frequency,
              :user_id

  attr_accessor :notes

  def initialize(data, id = nil)
    @id = id
    @name = data[:name]
    @category = data[:category]
    @mandatory = data[:mandatory]
    @event_date = data[:event_date]
    @frequency = data[:frequency]
    @time_needed = data[:time_needed].to_i
    @notes = data[:notes]
    @user_id = data[:user_id]
  end

  def hours
    @time_needed / 60 unless @time_needed.nil?
  end

  def minutes 
    @time_needed % 60 unless @time_needed.nil?
  end

  def mandatory 
    return true if @mandatory == "1"
    return false if @mandatory == "0"
    @mandatory
  end
end