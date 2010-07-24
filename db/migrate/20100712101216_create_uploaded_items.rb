class CreateUploadedItems < ActiveRecord::Migration
  def self.up
    create_table :uploaded_items do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      
      
      t.timestamps
    end
  end

  def self.down
    drop_table :uploaded_items
  end
end
