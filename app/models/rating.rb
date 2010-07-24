class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :temp_user
end
