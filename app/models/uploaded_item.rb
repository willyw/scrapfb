
require 'httparty'
require 'json'
require 'cgi'
require 'fileutils'
require 'ftools'
require 'fastercsv'
require 'yaml'
class UploadedItem < ActiveRecord::Base
  attr_accessor :fb_link
  belongs_to :user
  has_one :item
  has_many :uploaded_item_datas
  
  
  include HTTParty
  default_params :output => 'json'
  format :json
  URL = "https://graph.facebook.com/"
  PUBLIC_URL  = "http://graph.facebook.com/"
  def say_ho
    "hahahaha"
  end
  
  def send_result
    UserMailer.deliver_send_result(self)
  end
  
  
  def start_fire
    # "boom boom boom"
    get_node_details
    puts "We are in the scrap, fucking cool"
    hash = {:access_token => self.user.fb_access_token}
    url  = URL + self.fb_node_id.to_s
    url = url + "/feed"
    puts url + "?access_token=#{self.user.fb_access_token}"
    while(true) do 
      response_json = self.get_response( url , hash )
      puts "This is frmo here"
      puts response_json.inspect
      self.print_conversation( response_json )
      unless self.any_next_page?( response_json )
        break
      end
      hash =  self.set_next_hash( response_json['paging']['next'])
    end
    get_link
    make_csv
    make_data(20) # 20 day gap
    self.done  = true
    self.send_result
    Item.create(:uploaded_item_id => self.id )
    
    # send mail with attachment
  end
  
  def file_location
    dir_name = "#{RAILS_ROOT}/faster_csv/owner/#{self.user.id}/"
    file_name  = "#{self.id}_#{self.user.id}.csv"
    return dir_name + file_name
  end
  
  def get_node_pic
    url  = PUBLIC_URL + fb_node_id + "/picture?type=large"
    # photo_file_name is the link to the fb server
    photo_file_name = url
    self.save
  end
  
  
  def get_node_details
    # get pic
    get_node_pic
    
    url  = URL  + self.fb_node_id.to_s
    hash = {:access_token => self.user.fb_access_token}
    response_json = self.get_response( url , hash )
    self.title = response_json["name"]
    self.description = response_json["description"]
    self.link = response_json["link"]
    self.save
  end
  
  
  def get_link
   
    url  = URL 
    
    fields="name,link,email"
    ids =""
    for uploaded_item_data in uploaded_item_datas.all
      ids << uploaded_item_data.data_fb_id.to_s + ","
    end
    ids = ids.gsub(/,$/, '')
     hash = {:access_token => self.user.fb_access_token, 
       :fields => fields, :ids => ids}
    response_json = self.get_response( url , hash )
    puts response_json.inspect
    response_json.each do |key, value|
      UploadedItemData.find(:all, :conditions => {
        :data_fb_id => key,
        :uploaded_item_id => self.id
      }).each do | uid |
        uid.data_link = response_json[key]['link']
        uid.save
      end
    end
  end
  
  
  def make_csv
    dir_name = "#{RAILS_ROOT}/faster_csv/"
    # file name format
    # uploaded_item_id  + "_" + owner_id + ".csv"
      
   
    dir_name = "#{RAILS_ROOT}/faster_csv/owner/#{self.user.id}/"
    file_name  = "#{self.id}_#{self.user.id}.csv"
    if File.exist?( dir_name + file_name )
    else
      FileUtils.mkdir_p( dir_name ) # create the dir and all parent directories
      File.new(dir_name + file_name, 'w')
    end
    
    FasterCSV.open(dir_name + file_name, "w") do |csv|
      csv << ["fb_user_id", "Name", "link", "message"]
      # csv << ["willy", "17", "M"]
      #  csv << ["panda", "23", "F"]
      for uploaded_item_data in uploaded_item_datas
        array = []
        array << uploaded_item_data.data_fb_id.to_s
        array << uploaded_item_data.data_name
        array << uploaded_item_data.data_link
        array << uploaded_item_data.data_message
        csv << array
      end
    end
  end
  
  
  def set_next_hash( next_link )
    puts "Inside set_next_hash"
    collection_string = next_link.split('?').last
    hash = {}
    sentences = collection_string.split('&')
    for sentence in sentences
      key  = sentence.split('=').first
      value = sentence.split('=').last
      hash[key.to_sym] = CGI.unescape(value)
    end
    return hash
  end
  
  
  def any_next_page?(response_json)
    puts "Inside any_next_page"
    if response_json['paging'] and response_json['paging']['next']
      return true
    else
      return false
    end
  end
  
  def get_response( url, hash, parse = true)
    puts "Inside self.get_response"
    response = UploadedItem.get(url, :query => hash)
    if parse == false
      return response.body
    else
      return JSON.parse(response.body)
    end
  end
  
  def print_conversation( response_json )
    
    puts "Inside print_conversation"
    if response_json["data"].length == 0
      return
    else
      for entry in response_json["data"]
        # Data.create(:uploaded_item_id => self.id, 
        #   :data__name => entry['from']['name'], 
        #   :data_fb_id => entry['from']['id'],
        #   :data_message => entry['message']
        # )
        self.uploaded_item_datas.create(:data_name => entry['from']['name'], 
          :data_fb_id => entry['from']['id'],
          :data_message => entry['message'],
          :comment_created => entry["created_time"].to_datetime
        )
        puts "#{entry['from']['name']}  --- #{entry['from']['id']}   -- #{entry['message']} "
      end
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
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
  
  
  
  def make_data( day_gap = 1 )
    # get the axis value ( day )
    dates  = uploaded_item_datas.sort_by{|e| e.comment_created}.map do |e|
      e.comment_created.to_date
    end
    
    dates.uniq!
    
    posting = []
    dates.each do |date|
      number_of_posts = uploaded_item_datas.find(:all, :conditions=>["comment_created >= ? and comment_created<?", 
        date.to_datetime, date.to_datetime+ day_gap.day - 1.second] ).count
      posting << number_of_posts
    end
    
    ret_val = []
    ret_val << dates
    ret_val << posting
    hash = { :dates => dates, :posting => posting}
    # return ret_val
    create_yaml_container( hash )
    return hash
    # save as text_file somewhere?
    # read later before printing?
  end
  
  def create_yaml_container(hash_result) 
    self.yaml_container  = YAML::dump(hash_result)
    self.save
  end
  
  def extract_yaml
    ruby_obj = YAML::load( self.yaml_container)
  end
    
  
  private
  # def link_to_item
  #   item = Item.new
  #   item.uploaded_item_id = self.id
  #   item.save
  # end
end
