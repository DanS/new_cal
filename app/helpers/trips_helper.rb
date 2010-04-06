module TripsHelper
 
  def next_3_months_years(date)
    #given a date, returns an array of 3 arrays, each array containing
    #the month number and year number
    date = (date.strftime("%Y%m%d")) if date.class == Date
    output = []
    temp_date = Date.strptime(date[0,6] + '01', "%Y%m%d")
    3.times do
      output += [[temp_date.month, temp_date.year]]
      temp_date += 1.month
    end
    output
  end

  def time_selectors
    #returns a list of time selections for the time selection drop downs
    t = Time.parse('12:00AM')
    time_selections = Array.new(49) {|i| (t + i * 30.minutes).strftime("%I:%M%p")}
    time_selections[0] = 'Unknown'
    time_selections[1] = 'Midnight'
    time_selections[24] = 'Noon'
    return time_selections
  end

  def trips_in_week(day)
    #returns an array of dates and associated trips for given week
    dates = (0..6).to_a.collect {|i| day + i.days}
    week = {}
    dates.each do |day|
      week[day.strftime("%Y%m%d")] = Trip.all.select {|t| t.date.to_date == day}
    end
    return week
  end

  def ymd_to_date(date_string)
    Date.strptime(date_string, "%Y%m%d")
  end

  def next_month(date)
     date = ymd_to_date(date) unless date.class == Date
     (date + 1.month).strftime("%Y%m%d")
  end

  def prev_month(date)
    date = ymd_to_date(date) unless date.class == Date
    (date - 1.month).strftime("%Y%m%d")
  end

  def time_as_string(time_obj)
    if time_obj.class == Time
      time_obj.strftime("%I:%M%p")
    else
      return 'Unknown'
    end
  end
  
  def class_for_day(year, month, day)
    #return the destination class for a given date
    date = Date.parse("#{year}-#{month}-#{day}")
    dest_class = Trip.on_date(date).collect do |t|
      Destination.class_letter_for(t.destination)
    end.uniq.sort.join('') 
    return ('day ' + dest_class).strip
  end

  def class_for_trips(trips)
    trips.collect {|t| t.letter}.uniq.sort.join
  end
end
