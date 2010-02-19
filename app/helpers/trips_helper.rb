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

end