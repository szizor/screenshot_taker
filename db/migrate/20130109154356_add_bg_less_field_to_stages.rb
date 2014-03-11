class AddBgLessFieldToStages < ActiveRecord::Migration
  def self.up
    add_column :stages, :bg_less, :string
  end

  def self.down
    remove_column :stages, :bg_less
  end
end
