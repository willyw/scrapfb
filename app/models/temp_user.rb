require "digest/sha1"
class TempUser < ActiveRecord::Base
  has_many :ratings
  has_many :items, :through => :ratings
  # after_create :add_hash
  
  def add_stranger_key
    key = UUIDTools::UUID.timestamp_create.to_s
    salt = self.id.to_s
    combination = key + salt
    
    self.stranger_key = Digest::SHA1.hexdigest(combination )
    hexed = Digest::SHA1.hexdigest(combination )
    self.save
  end
  
  

  
private 

end
