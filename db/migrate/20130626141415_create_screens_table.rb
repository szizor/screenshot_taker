class CreateScreensTable < ActiveRecord::Migration
  def self.up
    create_table :screens do |t|
      t.string :name
      t.string :url
      t.boolean :processed, :default => false
      t.integer :installation_id
      t.integer :sitemap_id
      t.string :image_path
      t.timestamps
    end
  end

  def self.down
    drop_table :screens
  end
end
