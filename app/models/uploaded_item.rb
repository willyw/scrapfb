class UploadedItem < ActiveRecord::Base
  
  belongs_to :user
  has_one :item
  after_create :link_to_item
  has_attached_file :photo, 
      :styles =>  { 
        :index => "120x120>",
        :show => "510x510>",
        :teaser => "60x60>",
        :describe => "400x400>"
      },
      :url  => "/assets/products/:id/:style/:basename.:extension",
      :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"
      
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 10.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  
  private
  def link_to_item
    item = Item.new
    item.uploaded_item_id = self.id
    item.save
  end
end
