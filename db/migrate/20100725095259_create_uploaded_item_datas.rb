class CreateUploadedItemDatas < ActiveRecord::Migration
  def self.up
    create_table :uploaded_item_datas do |t|
      t.integer :uploaded_item_id
      t.string :data_name
      t.string :data_link
      t.string :data_fb_id
      t.string :data_message
      t.timestamps
    end
  end

  def self.down
    drop_table :uploaded_item_datas
  end
end
