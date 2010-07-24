require 'httparty'
class User < ActiveRecord::Base
  include HTTParty
  format :json
  default_params :output => 'json'
  
  has_many :ratings
  has_many :items, :through => :ratings
  
  has_many :uploaded_items
  
  acts_as_authentic do |c|
    # Email config
    c.merge_validates_format_of_email_field_options :message => "Hey, your email doesn't look like an email. Check this out: will@qtiest.com"
    c.merge_validates_uniqueness_of_email_field_options :message => "Someone has registered with this email address. Is that you?"
    c.merge_validates_length_of_email_field_options :within => 1..100
    # Password config
    c.merge_validates_length_of_password_field_options :message =>"Hey, to be secure, the password length has to be more than 6! I can haz more?"
    c.merge_validates_confirmation_of_password_field_options :message => "Umm, you must have been typing really fast. The password you typed doesn't match the password confirmation. Please key in the password and password confirmation"
  end
  
  
  has_attached_file :photo, 
      :styles =>  { 
        :profile => "200x200>",
        :display => "140x140>",
        :to_crop => "500x500>"
      },
      :url  => "/assets/users/:id/:style/:basename.:extension",
      :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"
      
  # validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 10.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  def send_mail
    UserMailer.deliver_welcome_email
  end
  
  def map_rating( current_stranger ) 
    for rating in current_stranger.ratings
      Rating.create(:user_id => self.id, 
        :item_id => rating.item_id,
        :rate => rating.rate )
    end
  end
  
 
  
end
