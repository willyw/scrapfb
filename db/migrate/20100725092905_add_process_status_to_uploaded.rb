class AddProcessStatusToUploaded < ActiveRecord::Migration
  def self.up
    add_column :uploaded_items, :done, :boolean, :default => false
  end

  def self.down
  end
end
