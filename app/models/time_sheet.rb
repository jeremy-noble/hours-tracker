class TimeSheet < ActiveRecord::Base
  attr_accessible :paid, :user_id
  belongs_to :user
end
