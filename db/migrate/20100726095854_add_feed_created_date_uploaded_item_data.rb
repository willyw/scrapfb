class AddFeedCreatedDateUploadedItemData < ActiveRecord::Migration
  def self.up
    add_column :uploaded_item_datas, :comment_created , :datetime
  end

  def self.down
  end
end
