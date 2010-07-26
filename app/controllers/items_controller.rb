class ItemsController < ApplicationController
  def show
    @item = Item.last
  end
  
  def index
    @item = Item.last
  end
  

  
private 
  

end
