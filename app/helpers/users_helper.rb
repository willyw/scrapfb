module UsersHelper
  
  
  # for forget email, hardcode it from the user.rb
  def show_error_on( attr_sym, object )
    if !object.errors or !object.errors.on(attr_sym)
      return nil
    end
    string = "<ul class='errMsg'>"
    
    for error in object.errors.on(attr_sym)
      string = string + "<li>"
      string = string + error
      string = string + "</li>"
    end
    
    string = string +  "</ul>"
    # string = string + link_to("somewhere", "http://google.com")
    return string
  end
  
end
