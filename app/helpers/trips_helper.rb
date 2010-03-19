module TripsHelper
 
  def next_3_months_years(start_date)
    #given a date, returns an array of 3 arrays, each array containing
    #the month number and year number
    output = []
    temp_date = Date.strptime(start_date[0,6] + '01', "%Y%m%d")
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

   def trips_in_week(week_num, year)
      #returns an array of dates and associated trips for given week
        week_num = "52" if week_num == "53"
        day = Date.strptime("#{week_num}:#{year}", "%U:%Y")
        dates = (0..6).to_a.collect {|i| day + i.days}
        week = {}
        dates.each do |day|
          week[day] = Trip.all.select {|t| t.date.to_date == day}
        end
        return week
    end

  def ymd_to_date(date_string)
    Date.strptime(date_string, "%Y%m%d")
  end

  def dates_between(start_string, end_string)
    #returns and array of strings representing all dates between start and end
    start_date = ymd_to_date(start_string)
    end_date = ymd_to_date(end_string)
    output = []
    tmp_date = start_date
    while tmp_date <= end_date
      output << tmp_date.strftime("%Y%m%d")
      tmp_date += 1.day
    end
    return output
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
