# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
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
      return val unless val.class == String
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
end
