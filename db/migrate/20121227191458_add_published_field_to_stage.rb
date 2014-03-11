class AddPublishedFieldToStage < ActiveRecord::Migration
  def self.up
    add_column :stages, :published, :boolean
  end

  def self.down
    remove_column :stages, :published
  end
end
