# # Filters added to this controller apply to all controllers in the application.
# # Likewise, all the methods added will be available for all controllers.
# 
# class ApplicationController < ActionController::Base
#   helper :all # include all helpers, all the time
#   protect_from_forgery # See ActionController::RequestForgeryProtection for details
# 
#   # Scrub sensitive parameters from your log
#   # filter_parameter_logging :password
# end


# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # include ExceptionNotifiable
  # include UCB::Rails::Security::ControllerMethods
    include ExceptionNotification::Notifiable 
    include ExceptionNotification::ConsiderLocal
    
    
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation
  
  
  protected 
  def user_layout( layout_name )
    layout_name || "application"
  end




  def local_request?
    false
  end

  exception_data :additional_data

  def additional_data
    current_user ? {:current_user => current_user } : {}
  end
      
      
      
  
  private
  
    def stranger_visit?
      current_user == nil 
    end

    def current_stranger
      return @current_stranger if defined?(@current_stranger)
      @temp_user = TempUser.find_by_id( session[:stranger_id] )
      if @temp_user and @temp_user.stranger_key == session[:stranger_key]
        @current_stranger = @temp_user
        return current_stranger
      else
        return nil 
      end
    end
    

  
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end