# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

#create communities
['Dancing Rabbit', 'Red Earth Farms', 'Sandhill'].each {|c| Community.create :name => c}
#create vehicles
['Truck', 'Black Jetta', 'Silver Jetta', 'Any', 'Sandhill', 'SSVC', 'Either Jetta'].each do |v|
  Vehicle.create :name => v
  
#create destinations: place => [letter, color]
{'Rutledge'    => ['R','#C60'], 
  'La Plata'   => ['P','#FF9'], 
  'Memphis'    => ['M','#9A9'], 
  'Kirksville' => ['K','#FC6'], 
  'Quincy'     => ['Q','#9CF'], 
  'Fairfield'  => ['F','#F99'], 
  'Ottumwa'    => ['O','#9C9'],
  'Other'      => ['E','#CCF']}.each_pair {|p, l| Destination.create :place => p, 
                                                                     :letter => l[0],
                                                                     :color => l[1] }
                      