class UploadedItemsController < ApplicationController
  # layout "dashboard"
  
  def index
    @uploaded_items = current_user.uploaded_items.reverse
  end
  
  def new
    @uploaded_item = UploadedItem.new
  end
  
  def create
    @uploaded_item = UploadedItem.new(params[:uploaded_item])
    @uploaded_item.user_id = current_user.id
    @uploaded_item.save
    
    if  params[:uploaded_item][:photo] 
      redirect_to second_step_url( @uploaded_item.id )
      return
    end
  end
  
  
  
  def second_step
    @uploaded_item = UploadedItem.find_by_id( params[:id] )
  end
  
  
  def update
    @uploaded_item = UploadedItem.find_by_id(  params[:id].to_i )
    @uploaded_item.update_attributes( params[:uploaded_item] ) 
    @uploaded_item.save
  end
end
