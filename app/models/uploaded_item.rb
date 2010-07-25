class UploadedItem < ActiveRecord::Base
  attr_accessor :fb_link
  belongs_to :user
  has_one :item
  # after_create :link_to_item
  # has_attached_file :photo, 
  #     :styles =>  { 
  #       :index => "120x120>",
  #       :show => "510x510>",
  #       :teaser => "60x60>",
  #       :describe => "400x400>"
  #     },
  #     :url  => "/assets/products/:id/:style/:basename.:extension",
  #     :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"
  #     
  # validates_attachment_presence :photo
  # validates_attachment_size :photo, :less_than => 10.megabytes
  # validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  # 
  # 
  def self.has_node_id(link )
    # regex = /(group\.php\?gid=[0-9]+)&?/
    regex = /(gid=[0-9]+)&?/
    link.match regex
    fb_node_id = $1
    if fb_node_id.size > 0 
      puts "Here is the matching url\n"*20
      puts fb_node_id
      puts fb_node_id.split('=').last
      
      return fb_node_id.split('=').last
    else
      return nil
    end
  end
  
  private
  # def link_to_item
  #   item = Item.new
  #   item.uploaded_item_id = self.id
  #   item.save
  # end
end
