class Screen < ActiveRecord::Base
  belongs_to :sitemap
  attr_accessible :processed, :sitemap_id, :url, :image_path, :processed, :name
end
