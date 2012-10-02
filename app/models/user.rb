class User < ActiveRecord::Base
  attr_accessible :name, :default_hourly_rate
  has_many :time_sheets

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, 
     :uniqueness => {:case_sensitive => false}
  validates :default_hourly_rate, numericality: true, allow_blank: true
end
