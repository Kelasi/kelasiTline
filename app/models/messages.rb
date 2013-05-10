class Messages < ActiveRecord::Base
  attr_accessible :msg, :user_id
end
