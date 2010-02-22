
def add_unordered_trips
  #setup for testing trips are returned/ displayed in order by date, departure time
  #trips in proper order will have :note text in sequential order 1-9
  today = Date.today
  ordered_datetimes = []
  ordered_datetimes << [today + 1.day, Time.parse('1:13AM'), 'trip-1']
  ordered_datetimes << [today + 1.day, Time.parse('11:56AM'), 'trip-2']
  ordered_datetimes << [today + 1.day, Time.parse('6:30PM'), 'trip-3']
  ordered_datetimes << [today + 8.days, Time.parse('1:13AM'), 'trip-4']
  ordered_datetimes << [today + 8.days, Time.parse('11:56AM'), 'trip-5']
  ordered_datetimes << [today + 8.days, Time.parse('6:30PM'), 'trip-6']
  ordered_datetimes << [today + 40.days, Time.parse('1:13AM'), 'trip-7']
  ordered_datetimes << [today + 40.days, Time.parse('11:56AM'), 'trip-8']
  ordered_datetimes << [today + 40.days, Time.parse('6:30PM'), 'trip-9']
  unordered_datetimes = ordered_datetimes.sort_by {rand}
  unordered_datetimes.each {|day, time, order| Factory(:trip, :date=>day, :depart=>time,
                                                       :notes=>order)}
end
