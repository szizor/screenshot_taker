class CreateSitemapsTable < ActiveRecord::Migration
  def self.up
    create_table :sitemaps do |t|
      t.string :url
      t.boolean :processed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sitemaps
  end
end
