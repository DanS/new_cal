require 'factory_girl'
require RAILS_ROOT + "/spec/factories"
cmtys = ['Dancing Rabbit', 'Sandhill', 'Red Earth Farms']
cars = ['Silver Jetta', 'Black Jetta', 'Truck', 'Either Jetta', 'SH', 'Other']
contacts = %w( Dan Alline Kurt Nathan Bear Alyssa Juan)
letters = %w(E F K L M O Q R)
colors = ['#FFCC66', '#FFFF99', '#99CC99', '#99CCFF', '#FF3D51', '#4F9C4F',
  'aqua', '#3D51FF']

#create communities
cmtys.each {|c| Community.create :name => c}
#create vehicles
cars.each do |v|
  Vehicle.create :name => v
end

#create destinations: place => [letter, color]
destinations = {'Rutledge'    => ['R','#C60'],
  'La Plata'   => ['P','#FF9'],
  'Memphis'    => ['M','#9A9'],
  'Kirksville' => ['K','#FC6'],
  'Quincy'     => ['Q','#9CF'],
  'Fairfield'  => ['F','#F99'],
  'Ottumwa'    => ['O','#9C9'],
  'Other'      => ['E','#CCF']}
destinations.each_pair do |p, l|
  Destination.create :place => p, :letter => l[0], :color => l[1]
end

#after destination table is created get rid of Other and subsitute some non-standard destinations
destinations.delete('Other')
['Chicago', 'Columbia', 'Detroit'].each {|d| destinations[d] = ['O', '#999']}
