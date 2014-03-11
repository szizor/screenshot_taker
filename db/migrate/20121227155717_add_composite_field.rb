class AddCompositeField < ActiveRecord::Migration
  def self.up
    add_column :stages, :composite, :string
  end

  def self.down
    remove_column :stages, :composite
  end
end
