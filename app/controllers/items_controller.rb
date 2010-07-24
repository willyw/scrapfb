class ItemsController < ApplicationController
  def show

  end
  
  def show_random
    if stranger_visit?
      @user = process_stranger
    else
      @user = current_user
    end
    
    @item = Item.give_relevant_item( @user )
    
    if @item == nil
      if current_user
        redirect_to join_uploader_or_invite_friends_url
      else
        redirect_to join_us_url
      end
    else
      @new_rating =  @item.ratings.build
    end
  end
  
  def play_error
    raise RuntimeError, "Generating an error"
  end
  
private 
  
  def process_stranger 
    if  familiar_stranger?
      @temp_user = TempUser.find_by_id( session[:stranger_id] )
      return @temp_user
    else
      @temp_user  = TempUser.create
      # set the cookies
      @temp_user.add_stranger_key
      session[:stranger_key] = @temp_user.stranger_key
      session[:stranger_id] = @temp_user.id
      return @temp_user
    end
  end
  
  def familiar_stranger?
    temp_user = TempUser.find_by_id( session[:stranger_id] )
    session[:stranger_key] and session[:stranger_id] and 
      indeed_familiar( temp_user.stranger_key.to_s, session[:stranger_key].to_s)
  end
  
  def indeed_familiar( temp_user_key, stranger_key )
    temp_user_key == stranger_key
  end
  
end
