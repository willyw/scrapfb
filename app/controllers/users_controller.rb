require 'cgi'

class UsersController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  API_KEY = 'e4de6a450580adedbdadf124fba63e11'
  APP_SECRET = '3368a580517b3cc316c9293cf24619fc'
  APP_ID  = '135319876508646'
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.save
    if current_stranger
      puts "There is current_stranger!"
      @user.map_rating( current_stranger )
    end

    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to :action => "show", :success => true, :after_change => true
    else
      # puts "This is the error\n"*10
      # @user.errors.each_error{ |boom, err| puts "#{boom} - #{err.class} - #{err.type} - #{err.message} " } 
      # 
      # puts "#{@user.errors.on(:password)}\n"*13
      # puts "#{@user.errors.on(:password).class}\n"*10
      # puts "For email #{@user.errors.on(:email)}\n"*10
      # if @user.errors_
      redirect_to :action => "show", :success => false, :after_change => true
    end
  end
  
  def join_us
    @temp_user = current_stranger
    @items = @temp_user.items.find(:all, :limit => 3)
    @user = User.new
  end
  
  def join_uploader_or_invite_friends
    @user = current_user
    @items = @user.items.find(:all, :limit => 3)
  end
  
  def oauth_redirect
    
    if params[:code]
      base_url = "https://graph.facebook.com/oauth/access_token"
      # base_url << "client_id=#{APP_ID}&"
      # base_url  << "redirect_uri=#{CGI.escape('http://localhost:3000/oauth_redirect')}&"
      # base_url <<"client_secret=#{APP_SECRET}&"
      # base_url << "code=#{params[:code]}"
      # post get, we will get access_token.. just do JSON GET
      puts "hahahahaha, here we are!!!!!\n"*30
      @result =  User.get( base_url, :query => {
        :client_id => APP_ID ,
        :redirect_uri => 'http://localhost:3000/oauth_redirect',
        :client_secret => APP_SECRET,
        :code  => params[:code]
        } )
        puts @result.inspect
        puts "The access token is \n"*30
        puts @result.parsed_response
        result_hash = {}
        @result.parsed_response.split('&').each do |string_response|
          arr = string_response.split('=')
          result_hash[arr[0]] = arr[1]
        end
        @access_token = result_hash['access_token']
        if @access_token
          current_user.fb_access_token = @access_token
          current_user.save
        end
      return
    else
      base_url = "https://graph.facebook.com/oauth/authorize?"
      base_url << "client_id=#{APP_ID}&"
      base_url  << "redirect_uri=#{CGI.escape('http://localhost:3000/oauth_redirect')}&"
      base_url << "scope=offline_access&"
      base_url << "display=popup"
      redirect_to base_url
      return
    end
  end
  
  def try_oauth
    puts "Are you ready"
  end
  
  
end