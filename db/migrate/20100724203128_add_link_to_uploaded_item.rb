class AddLinkToUploadedItem < ActiveRecord::Migration
  def self.up
    add_column :uploaded_items, :link, :string
  end

  def self.down
  end
end
