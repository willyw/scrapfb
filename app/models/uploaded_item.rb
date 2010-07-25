
require 'httparty'
require 'json'
require 'cgi'
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
      puts response_json.inspect
      self.print_conversation( response_json )
      unless self.any_next_page?( response_json )
        break
      end
      hash =  self.set_next_hash( response_json['paging']['next'])
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
