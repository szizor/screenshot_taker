class AddViewportFieldToStages < ActiveRecord::Migration
  def self.up
    add_column :stages, :viewport, :string, :default => "1280x1024"
  end

  def self.down
    remove_column :stages, :viewport
  end
end
