class User < ActiveRecord::Base
  attr_accessible :name
  has_many :time_sheets

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, 
     :uniqueness => {:case_sensitive => false}
end
