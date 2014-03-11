class CreateShotsTable < ActiveRecord::Migration
  def self.up
    create_table :stages do |t|
      t.string :name
      t.text :content
      t.string :stage_image
      t.string :output_image

      t.timestamps
    end
  end

  def self.down
    drop_table :stages
  end
end
