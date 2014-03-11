class ImageType < ActiveRecord::Base
  attr_accessible :name
  has_many :stages
end
