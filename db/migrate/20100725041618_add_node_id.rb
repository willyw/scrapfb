class AddNodeId < ActiveRecord::Migration
  def self.up
    rename_column :uploaded_items, :link, :fb_node_id
  end

  def self.down
  end
end
