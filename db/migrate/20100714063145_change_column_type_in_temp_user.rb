class ChangeColumnTypeInTempUser < ActiveRecord::Migration
  def self.up
    change_column :temp_users, :stranger_key, :string
  end

  def self.down
  end
end
