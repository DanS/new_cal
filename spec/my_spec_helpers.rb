require RAILS_ROOT + '/app/helpers/trips_helper'
include TripsHelper

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

def days_in_month(month, year)
  lengths = [nil, 31, 28, 31, 30, 31, 30, 31, 31,30, 31, 30, 31]
  leap = year % 4 == 0 && month == 2 ? 1 : 0 #not totally accurate but good enough
  lengths[month] + leap
end

def weekend_days_in_month(month, year)
  #returns a hash, keys are day numbers values are true/ false if weekend or not
  length = days_in_month(month,year)
  is_wk_end = {}
  (1..length).each do |dayn|
    day = Date.parse("#{year}#{sprintf("%02d", month)}#{sprintf("%02d", dayn)}")
    is_wk_end[dayn] = day.wday == 0 || day.wday ==6
    #puts "#{year}#{sprintf("%02d", month)}#{sprintf("%02d", dayn)} is #{is_wk_end[dayn]}"
  end
  is_wk_end
end

def day_class_for(date)
  day_class = []
  day_class << TripsHelper.class_for_day(*date.strftime("%Y,%m,%d").split(',')) 
  day_class << 'past' if date < Date.today
  day_class << 'weekendDay' if [0,6].include?(date.wday)
  day_class << 'today' if date == Date.today
  return day_class.join(' ').gsub('  ', ' ').strip
end