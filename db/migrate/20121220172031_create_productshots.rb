class CreateProductshots < ActiveRecord::Migration
  def self.up
    create_table :productshots do |t|
      t.string :name
      t.string :image
      t.timestamps
    end
  end

  def self.down
    drop_table :productshots
  end
end
