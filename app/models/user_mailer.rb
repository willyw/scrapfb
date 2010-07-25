require 'cgi'

class UserMailer < ActionMailer::Base
  def welcome_email
    recipients    "rajakuraemas@gmail.com"
    from          "[qTiest]Welcome Notification<notifications@example.com>"
    subject       "Welcome to My Awesome Site"
    sent_on       Time.now
  end

  def send_result(uploaded_item)
      recipients      uploaded_item.user.email
      subject         "Group Data is Ready(gid=#{uploaded_item.fb_node_id})"
      from            "[fbScrap]CutyCreator<notifications@example.com>"
      content_type    "text/html"

      attachment :content_type => "text/csv",
        :body => File.read(uploaded_item.file_location),
        :filename =>File.basename("#{uploaded_item.id}_#{uploaded_item.user.id}.csv")
  end
    
    
end
