# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def show_qtiest?( params )
    condition_1_qtiest?(params) or
      condition_2_qtiest?(params) or
        condition_3_qtiest?(params)
  end
  
  def show_mycute?( params )
    params[:controller] == "uploaded_items"
  end
  
  def show_cuteProfile?( params )
    params[:controller] == "users" and params[:action] =="show" 
  end
  
  
  
  def error_for(object, method = nil, options={})
    if method
      err = instance_variable_get("@#{object}").errors.on(method).to_sentence rescue instance_variable_get("@#{object}").errors.on(method)
    else
      err = @errors["#{object}"] rescue nil
    end
    options.merge!(:class=>'fieldWithErrors', :id=>"#{[object,method].compact.join('_')}-error", :style=>(err ? "#{options[:style]}" : "#{options[:style]};display: none;"))
    content_tag("p",err || "", options )     
  end


  private
    def condition_1_qtiest?(params)
      params[:controller] == "items" and params[:action] == "show_random" 
    end
    
    def condition_2_qtiest?(params)
      params[:controller] == "users" and params[:action] == "join_us" 
    end
    
    def condition_3_qtiest?(params)
      params[:controller] == "users" and params[:action] == "join_uploader_or_invite_friends" 
    end
end
