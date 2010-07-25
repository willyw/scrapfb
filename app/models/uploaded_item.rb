
require 'httparty'
require 'json'
require 'cgi'
require 'fileutils'
require 'ftools'
require 'fastercsv'
class UploadedItem < ActiveRecord::Base
  attr_accessor :fb_link
  belongs_to :user
  has_one :item
  has_many :uploaded_item_datas
  
  
  include HTTParty
  default_params :output => 'json'
  format :json
  URL = "https://graph.facebook.com/"
  
  def say_ho
    "hahahaha"
  end
  
  def start_fire
    # "boom boom boom"
    puts "We are in the scrap, fucking cool"
    hash = {:access_token => self.user.fb_access_token}
    url  = URL + self.fb_node_id.to_s
    url = url + "/feed"
    puts url
    while(true) do 
      response_json = self.get_response( url , hash )
      # puts response_json.inspect
      self.print_conversation( response_json )
      unless self.any_next_page?( response_json )
        break
      end
      hash =  self.set_next_hash( response_json['paging']['next'])
    end
    get_link
    make_csv
  end
  
  
  def get_link
    hash = {:access_token => self.user.fb_access_token}
    url  = URL + self.fb_node_id.to_s
    
    for uploaded_item_data in uploaded_item_datas.all(:limit => 3)
     url  = URL + uploaded_item_data.data_fb_id
     response_json = self.get_response( url, hash )
     uploaded_item_data.data_link =  response_json["link"]
     uploaded_item_data.save
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
  
  def get_response( url, hash)
    puts "Inside self.get_response"
    response = UploadedItem.get(url, :query => hash)
    return JSON.parse(response.body)
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
          :data_message => entry['message']
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
  
  
  def scrap
  end
  
  private
  # def link_to_item
  #   item = Item.new
  #   item.uploaded_item_id = self.id
  #   item.save
  # end
end
