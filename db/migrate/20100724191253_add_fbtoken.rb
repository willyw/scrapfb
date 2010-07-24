class AddFbtoken < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_access_token , :string
  end

  def self.down
  end
end
