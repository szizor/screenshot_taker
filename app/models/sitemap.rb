class Sitemap < ActiveRecord::Base
  attr_accessible :url
  has_many :screens, :dependent => :destroy

  def has_finished
    finish = true
    self.screens.map{|s| finish = false if s.processed == false}
    finish
  end
end
