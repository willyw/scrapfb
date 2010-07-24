class AddTempUserIdToRating < ActiveRecord::Migration
  def self.up
    add_column :ratings, :temp_user_id, :integer
  end

  def self.down
  end
end
