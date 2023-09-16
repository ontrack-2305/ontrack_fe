

def generate_tasks_for(user)
  @facade.post({:name=>"Water Plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Remember plants in bedroom, living room, and balcony", :time_needed=>20}, user.id)
  @facade.post({:name=>"Prune Plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Remember plants in bedroom, living room, and balcony", :time_needed=>20}, user.id)
  @facade.post({:name=>"Repot Plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Remember plants in bedroom, living room, and balcony", :time_needed=>40}, user.id)
  @facade.post({:name=>"Wash Dishes", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"", :time_needed=>30}, user.id)
  @facade.post({:name=>"Clean Room", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"Pick up clothes, vacuum, clear off desk", :time_needed=>120}, user.id)
  @facade.post({:name=>"Buy more plants", :category=>"chore", :mandatory=>"1", :event_date=>"", :frequency=>"weekly", :notes=>"I need them", :time_needed=>60}, user.id)
end

def delete_tasks_for(user)
  tasks = @facade.get_tasks(user.id)
  tasks.each do |task|
    @facade.delete(task.id, user.id)
  end
end
