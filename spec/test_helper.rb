def stub_user
  @user = User.create({id: "123", first_name: "John"})
  allow(User).to receive(:from_google_auth).and_return(@user)
  allow(@user).to receive(:errors).and_return(nil)
  allow(User).to receive(:find_by).and_return(@user)
  allow(User).to receive(:find).and_return(@user)
end

def generate_tasks_for(user)
  @facade.post({:name=>"Water Plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Remember plants in bedroom, living room, and balcony"}, user.id)
  @facade.post({:name=>"Clean fish tank", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Vacuum the gravel, wipe algae off plants"}, user.id)
  @facade.post({:name=>"Take nice bath", :category=>"rest", :mandatory=>"0", :event_date=>"", :frequency=>"monthly", :notes=>"Remember the fancy bathbombs under the cupboard, get a milkshake and light a candle"}, user.id)
  @facade.post({:name=>"Meditate", :category=>"rest", :mandatory=>"0", :event_date=>"", :frequency=>"daily", :notes=>""}, user.id)
  @facade.post({:name=>"Practice guitar", :category=>"hobby", :mandatory=>"0", :event_date=>"", :frequency=>"daily", :notes=>"Do scale exercises, work through the books I bought"}, user.id)
  @facade.post({:name=>"Practice drawing", :category=>"hobby", :mandatory=>"0", :event_date=>"", :frequency=>"daily", :notes=>"Do some studies on hands and gestures"}, user.id)
end

def delete_tasks_for(user)
  tasks = @facade.get_tasks(user.id)
  tasks.each do |task|
    @facade.delete(task.id, user.id)
  end
end
