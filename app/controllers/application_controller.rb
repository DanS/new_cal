# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :date2string
  protect_from_forgery # See ActionController::RequestForgeryProtection for details 
  
  def param_session_default(arg, default)
    #if arg is in params use that value and save it in session
    #else if arg is in session use that, otherwise use default value
    #if param value is 'clear' set session value to nil and return nil
    #if param value is a string that can parse as a date a date object is returned
    arg = arg.to_s #ensure arg not a symbol
    case
    when params.has_key?(arg)
      new_value = params[arg] == 'clear' ? nil : params[arg]
      session[arg] = new_value
      return try2make_date(new_value)
    when session[arg]
      return try2make_date(session[arg])
    else
      return try2make_date(default)
    end
  end

  def plus_3_months(date)
    date = Date.parse(date) unless date.class == Date
    (date + 3.months).strftime("%Y%m%d")
  end

  def start_date_for_week(date)
      first_day_of_current_week = Date.today - Date.today.wday.days
      if date < first_day_of_current_week
        return first_day_of_current_week.strftime("%Y%m%d")
      else
        return (date - date.wday.days).strftime("%Y%m%d")
      end
    end

  def first_day_of_week(date)
    date = Date.parse(date) if date.class == String
    (date - date.wday.days).strftime("%Y%m%d")
  end

  def end_of_week(date)
    date = Date.parse(date) unless date.class == Date
    (date + 6.days).strftime("%Y%m%d")
  end

  def date2string(date)
    date.strftime("%Y%m%d")
  end

  def dates_between(start_date, end_date)
    #returns and array of strings representing all dates between start and end
    start_date = Date.parse(start_date) if start_date.class == String
    end_date = Date.parse(end_date) if end_date.class == String
    output = {}
    tmp_date = start_date
    while tmp_date <= end_date
      output[tmp_date.strftime("%Y%m%d")] = []
      tmp_date += 1.day
    end
    return output
  end

  def to_destination_list(trips_by_date)
    output = {}
    collected_destinations = trips_by_date.values.flatten.collect {|t| [t.destination, t.letter]}
    collected_destinations.uniq.each do |pair|
      count = collected_destinations.select {|p| p == pair}.length
      output[pair[0]] = [count, pair[1]]
    end
    output
  end

  private

  def try2make_date(val)
    #if value can parse as a date, return a date obj, otherwise return value
    return val unless val.class == String  && val =~ /\d{8}/
    begin
      Date.parse(val)
    rescue
      return val
    end
  end

end
