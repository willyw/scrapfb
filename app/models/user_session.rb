class UserSession < Authlogic::Session::Base
  # validate :check_if_awesome
  # 
  # private
  # def check_if_awesome
  #   errors.add(:email, "must contain awesome") if email && !email.include?("awesome")
  #   errors.add(:base, "You must be awesome to log in") unless attempted_record.awesome?
  # end
  
end