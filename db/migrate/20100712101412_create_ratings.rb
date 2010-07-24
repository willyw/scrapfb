class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :rate, :default => 0
      
      t.integer :user_id
      t.integer :item_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
