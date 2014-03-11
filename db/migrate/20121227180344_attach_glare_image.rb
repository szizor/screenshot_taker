class AttachGlareImage < ActiveRecord::Migration
  def self.up
    add_column :stages, :glare_image, :string
  end

  def self.down
    remove_column :stages, :glare_image
  end
end
