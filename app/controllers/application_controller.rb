# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :date2string
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def param_session_default(arg, default)
    #if arg is in params use that value and save it in session
    #else if arg is in session use that, otherwise use default value
    #if param value is 'clear' set session value to nil and return nil
    #if param value is a string that can parse as a date a date object is returned
    def try2make_date(val)
      #if value can parse as a date, return a date obj, otherwise return value
      return val unless val.class == String  && val =~ /\d{8}/
      begin
        Date.parse(val)
      rescue 
        return val
      end
    end
    arg = arg.to_s #ensure arg not a symbol
    case
      when params.has_key?(arg)
        new_value = params[arg] == 'clear' ? nil : params[arg]
        session[arg] = new_value
        return try2make_date(new_value)
      when session.has_key?(arg)
        return try2make_date(session[arg])
      else
        return try2make_date(default)
    end
  end

  def plus_3_months(date)
    date = Date.parse(date) unless date.class == Date
    (date + 3.months).strftime("%Y%m%d")
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
    start_date = ymd_to_date(start_date) if start_date.class == String
    end_date = ymd_to_date(end_date) if end_date.class == String
    output = {}
    tmp_date = start_date
    while tmp_date <= end_date
      output[tmp_date.strftime("%Y%m%d")] = []
      tmp_date += 1.day
    end
    return output
  end

end
