require 'cgi'

class UserMailer < ActionMailer::Base
  def welcome_email
    recipients    "rajakuraemas@gmail.com"
    from          "[qTiest]Welcome Notification<notifications@example.com>"
    subject       "Welcome to My Awesome Site"
    sent_on       Time.now
    
  end

end
