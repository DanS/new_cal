#aid for visually verifying wip display

require '/Users/dan/projects/rails/new_cal/config/environment'
require 'factory_girl'
require '/Users/dan/projects/rails/new_cal/spec/factories'

Trip.delete_all
start_date = Date.today - Date.today.wday.days
start_time = Time.parse("12AM")
vehicles = ['Any', 'Other', 'Black Jetta', 'Either Jetta', 'Silver Jetta', 'Truck', 'Sand Hill', 'Slippery']
hours = ["12:00AM", "12:30AM", "1:00AM", "1:30AM", "2:00AM", "2:30AM", "3:00AM", "3:30AM", "4:00AM", "4:30AM", "5:00AM", "5:30AM", "6:00AM", "6:30AM", "7:00AM", "7:30AM", "8:00AM", "8:30AM", "9:00AM", "9:30AM", "10:00AM", "10:30AM", "11:00AM", "11:30AM", "12:00PM", "12:30PM", "1:00PM", "1:30PM", "2:00PM", "2:30PM", "3:00PM", "3:30PM", "4:00PM", "4:30PM", "5:00PM", "5:30PM", "6:00PM", "6:30PM", "7:00PM", "7:30PM", "8:00PM", "8:30PM", "9:00PM", "9:30PM", "10:00PM", "10:30PM", "11:00PM", "11:30PM"]

#create staircase of trips on first day
3.times do
  vehicles.each do |v|
    end_time = start_time + 1.hours
    Factory(:trip, :date=>start_date, :depart=>start_time, :return=>end_time, :preferred_vehicle=>v)
    start_time = start_time + 1.hour
  end
  vehicles.reverse!
end
  
  #create checker board of trips on second day
  vehicles.each_with_index do |v, i|
    (0..47).map {|x| [x, x + 0.5]}.flatten.each do |hour|
      if (hour + i) % 2 == 0
        Factory(:trip, 
          :date => start_date + 1.day,
          :preferred_vehicle => v,
          :depart => hours[hour],
          :return => hours[hour + 1])
      end
    end
  end