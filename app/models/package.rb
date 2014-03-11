class Package < ActiveRecord::Base
 attr_accessible :name, :licence_type, :width, :height, :price

end
