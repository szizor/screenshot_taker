class Productshot < ActiveRecord::Base
  belongs_to :job, :dependent => :destroy, :class_name => "Delayed::Job"
  attr_accessible :name
  require 'aws/s3'

  def self.clean_old_records
      Productshot.destroy_all(['created_at <= ? ', 3.days.ago.to_time])
  end

end
