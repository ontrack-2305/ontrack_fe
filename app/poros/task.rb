class Task
  attr_reader :id,
              :name,
              :category,
              :mandatory,
              :event_date,
              :time_needed,
              :frequency,
              :user_id,
              :image

  attr_accessor :notes

  def initialize(data, id = nil)
    @id = id
    @name = data[:name]
    @category = data[:category]
    @mandatory = data[:mandatory]
    @event_date = data[:event_date]
    @frequency = data[:frequency]
    @time_needed = data[:time_needed]
    @notes = data[:notes]
    @user_id = data[:user_id]
    @image = data[:image]
  end

  def hours
    @time_needed / 60 unless @time_needed.nil?
  end

  def minutes 
    @time_needed % 60 unless @time_needed.nil?
  end
end