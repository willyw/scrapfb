class AddRegisteredColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :registered, :boolean, :default => false
  end

  def self.down
  end
end
