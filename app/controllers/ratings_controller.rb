class RatingsController < ApplicationController
  def create
    if stranger_visit?
      @user = current_stranger
    else
      @user = current_user
    end
    
    @rating = @user.ratings.create( params[:rating] )
    @rating.item_id = params[:item_id]
    @rating.save
    
    # find the next qtiest
    redirect_to show_random_url
  end
end
