class CreateSitemapsTable < ActiveRecord::Migration
  def self.up
    create_table :sitemaps do |t|
      t.string :url
      t.boolean :processed, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :sitemaps
  end
end
