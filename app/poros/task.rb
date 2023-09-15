class Task
  attr_reader :id,
              :name,
              :category,
              :mandatory,
              :event_date,
              :time_needed,
              :frequency,
              :notes,
              :user_id

  def initialize(data)
    @id = data[:id]
    @name = data[:attributes][:name]
    @category = data[:attributes][:category]
    @mandatory = data[:attributes][:mandatory]
    @event_date = data[:attributes][:event_date]
    @frequency = data[:attributes][:frequency]
    @time_needed = data[:attributes][:time_needed]
    @notes = data[:attributes][:notes]
    @user_id = data[:attributes][:user_id]
  end

  def hours
    @time_needed / 60
  end

  def minutes 
    @time_needed % 60
  end
end