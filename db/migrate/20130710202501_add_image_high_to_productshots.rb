class AddImageHighToProductshots < ActiveRecord::Migration
  def change
    add_column :productshots, :image_high, :string
  end
end
