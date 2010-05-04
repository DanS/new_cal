desc "create random trips"
task :create_trips => :environment do

  cmtys = ['Dancing Rabbit', 'Sandhill', 'Red Earth Farms']
  cars = ['Silver Jetta', 'Black Jetta', 'Truck', 'Either Jetta', 'SH', 'Other']
  contacts = %w( Dan Alline Kurt Nathan Bear Alyssa Juan)
  destinations = [ 'Rutledge', 'La Plata', 'Memphis', 'Kirksville', 'Quincy', 'Fairfield','Ottumwa', 'Other']

  # loads random trips
  90.times do
    t = Trip.new
    t.date = Date.today + rand(90).days
    h = rand(24)
    m = [0, 15, 30, 45].rand
    t.depart = Time.parse("#{h}:#{m}")
    t.return = t.depart + (rand(8).hours) 
    t.contact = contacts.rand
    t.community = cmtys.rand
    t.preferred_vehicle = cars.rand
    t.travelers = (1..4).to_a.rand
    t.destination = destinations.rand
    t.notes = 'Lorium Ipsum et cetera ' * rand(6)
    t.save
  end
end
