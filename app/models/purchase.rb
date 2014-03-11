class Purchase < ActiveRecord::Base
  attr_accessible :email, :customer_id, :plan_id, :first_name, :last_name, :card_token
  attr_accessor :card_token
end
