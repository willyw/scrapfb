class UploadedItemsController < ApplicationController
  # layout "dashboard"
 
  def index
    @uploaded_items = current_user.uploaded_items.reverse
  end
  
  def new
    @uploaded_item = UploadedItem.new
    if params[:prev_uploaded_item] 
      @prev_uploaded = UploadedItem.find_by_id(params[:prev_uploaded_item])
    end
  end
  
  def create
    unless link_present and (fb_node_id = valid_link )
      redirect_to new_uploaded_item_url(:link_invalid => true)
      return
    end
    
    puts "We are in the create\n"*30
    puts "The node link is #{fb_node_id}\n"*10
    @uploaded_item = current_user.uploaded_items.new
    @uploaded_item.fb_node_id = fb_node_id
    if @uploaded_item.save
      puts "Yohoooo, we are saving! "
    end
    redirect_to  new_uploaded_item_url(:prev_uploaded_item => @uploaded_item.id )
    return 
  end
  
  
  def valid_link
    link = params[:uploaded_item][:fb_link]
    fb_node_id = UploadedItem.has_node_id( link )
    return fb_node_id
  end
  
  def link_present
    params[:uploaded_item][:fb_link] and params[:uploaded_item][:fb_link].size !=0
  end

end
