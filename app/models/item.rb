class Item < ActiveRecord::Base
  has_many :ratings
  has_many :users, :through => :ratings
  has_many :temp_users, :through => :ratings
  belongs_to :uploaded_item
  
  def self.give_relevant_item( user ) 
    
    # phase 0. get the list of item has not been viewed
    unviewed_items = self.give_unviewed_item_for( user )
    
    # phase 1. give the recommended item
    unviewed_items.first
    # phase 2. if all the recommended item are shown, 
      # show the non-recommended
    
    # phase 3. if there is no item to be shown, 
      # show the call for joining qTiest
  end
  
  def self.give_unviewed_item_for( user )
    Item.all - user.items
  end
end
