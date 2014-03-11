class AddSharedImageTable < ActiveRecord::Migration
  def self.up
    create_table :shared_images do |t|
      t.string :slug
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :shared_images
  end
end
