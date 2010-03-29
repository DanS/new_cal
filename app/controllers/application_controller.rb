# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def assign_from_param_session_or_default(arg, default)
    #if arg is in params use that value and save it in session
    #else if arg is in session use that, otherwise use default value
    arg = arg.to_s
    case
      when params.has_key?(arg)
        session[arg] = params[arg]
        return params[arg]
      when session.has_key?(arg)
        return session[arg]
      else
        return default
    end
  end
end
