def rand_time
  m = [0, 15, 30, 45].random_element
  h = rand(24)
  Time.parse("#{h}:#{m}")
end

@destinations = %w(Kirksville Rutledge Fairfield Quincy Ottumwa Chicago Detroit)
cmtys = ['Dancing Rabbit', 'Sandhill', 'Red Earth Farms']
cars = ['Silver Jetta', 'Black Jetta', 'Truck', 'Either Jetta', 'SH', 'Other']

Factory.define :trip do |trip|
  trip.travelers 1
  trip.destination 'Rutledge'
  trip.date Date.today
  trip.contact 'Joe'
  trip.notes 'Lorium Ipsum et cetera '
  trip.preferred_vehicle 'Truck'
  trip.depart Time.parse("12:15")
  trip.return Time.parse("17:15")
  trip.community 'Dancing Rabbit'
    end

Factory.define :random_trip do |trip|
  trip.travelers((1..8).to_a.random_element)
  trip.destination @destinations.random_element
  trip.date Date.today + rand(90).days
  trip.contact ['Joe', 'Dan', 'Sally', 'Temperance', 'Shirley']
  trip.notes 'Lorium Ipsum et cetera ' * rand(6)
  trip.preferred_vehicle cars.random_element
  trip.return rand_time
  trip.depart rand_time
  trip.community cmtys.random_element
end

Factory.define :destination do |dest|
  dest.place 'Rutledge'
  dest.letter 'R'
  dest.color '#FFC'
end

Factory.define :community do |community|
  community.name cmtys.random_element
end

Factory.define :vehicle do |vehicle|
  vehicle.sequence(:name) { |n| "car-#{n}" }
  vehicle.color 'red'
  vehicle.not_dr_vehicle '0'
  vehicle.firm_assignment '1'
end