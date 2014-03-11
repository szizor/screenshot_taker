class AddPositionToStages < ActiveRecord::Migration
  def self.up
    add_column :stages, :position, :integer
  end

  def self.down
    remove_column :stages, :position
  end
end
