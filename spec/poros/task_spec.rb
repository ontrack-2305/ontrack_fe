require "rails_helper"

RSpec.describe Task do
  it "has an id, name, category, mandatory boolean, event date, frequency, time needed, notes, and user id" do
    task = Task.new({:name=>"thing2", :category=>"hobby", :mandatory=>false, :event_date=>nil, :frequency=>"weekly", :time_needed=>20, :notes=>"stuff", :user_id=>"2"}, "26")

    expect(task.id).to eq("26")
    expect(task.name).to eq("thing2")
    expect(task.category).to eq("hobby")
    expect(task.mandatory).to eq(false)
    expect(task.event_date).to eq(nil)
    expect(task.frequency).to eq("weekly")
    expect(task.time_needed).to eq(20)
    expect(task.notes).to eq("stuff")
    expect(task.user_id).to eq("2")
  end

  it "can calculate hours and minutes" do
    task = Task.new({:name=>"thing2", :category=>"hobby", :mandatory=>false, :event_date=>nil, :frequency=>"weekly", :time_needed=>100, :notes=>"stuff", :user_id=>"2"}, "26")

    expect(task.hours).to eq(1)
    expect(task.minutes).to eq(40)
  end

  it "can update notes" do
    task = Task.new({:name=>"thing2", :category=>"hobby", :mandatory=>false, :event_date=>nil, :frequency=>"weekly", :time_needed=>100, :notes=>"stuff", :user_id=>"2"}, "26")

    expect(task.notes).to eq("stuff")
    task.notes = "new notes"
    expect(task.notes).to eq("new notes")
  end
end