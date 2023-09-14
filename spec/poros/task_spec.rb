require "rails_helper"

RSpec.describe Task do
  it "has an id, name, category, mandatory boolean, event date, frequency, time needed, notes, and user id" do
    task = Task.new({:id=>"26",
      :type=>"task",
      :attributes=>{:name=>"thing2", :category=>1, :mandatory=>false, :event_date=>nil, :frequency=>2, :time_needed=>20, :notes=>"stuff", :prerequisite=>nil, :user_id=>"2"}})

    expect(task.id).to eq("26")
    expect(task.name).to eq("thing2")
    expect(task.category).to eq("Hobby")
    expect(task.mandatory).to eq(false)
    expect(task.event_date).to eq(nil)
    expect(task.frequency).to eq("Weekly")
    expect(task.time_needed).to eq(20)
    expect(task.notes).to eq("stuff")
    expect(task.user_id).to eq("2")
  end
end