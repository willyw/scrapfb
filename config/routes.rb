ActionController::Routing::Routes.draw do |map|
  
  map.root  :controller => "user_sessions", :action => "new"
  map.generate_error "/generate_error" , :controller => "items", :action => "play_error"
  map.register "/register", :controller => "users", :action => "new"
  map.login "/login",:controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"
  map.join_us '/join_us' , :controller => "users", :action => "join_us"
  map.join_uploader_or_invite_friends '/join_uploader_or_invite_friends' , :controller => "users", :action =>"join_uploader_or_invite_friends"
  
  map.oauth_start "/oauth_redirect", :controller => "users", :action =>"oauth_redirect"
  map.try_oauth "/try_oauth", :controller => "users", :action => "try_oauth"
  
  map.show_completed_scrapd "/completed_scrapds" , :controller => "items", :action => "index"
  map.second_step "/uploaded_item/second_step/:id", :controller => "uploaded_items", :action => "second_step"
  map.resource :user_session
  
  
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :uploaded_items
 
 
  map.resources :items do |items|
      items.resources :ratings
  end
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
