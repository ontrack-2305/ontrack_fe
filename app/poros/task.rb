class Task 
  attr_reader :id,
              :name,
              :type,
              :mandatory,
              :event_date,
              :frequency,
              :time_needed,
              :notes,
              :user_id
              
  def initialize(data)
    @id = data[:id]
    @name = data[:attributes][:name]
    @type = data[:attributes][:type]
    @mandatory = data[:attributes][:mandatory]
    @event_date = data[:attributes][:event_date]
    @frequency = data[:attributes][:frequency]
    @time_needed = data[:attributes][:time_needed]
    @notes = data[:attributes][:notes]
    @user_id = data[:attributes][:user_id]
  end
end