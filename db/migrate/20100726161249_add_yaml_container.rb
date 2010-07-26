class AddYamlContainer < ActiveRecord::Migration
  def self.up
    add_column :uploaded_items , :yaml_container, :text
  end

  def self.down
  end
end
