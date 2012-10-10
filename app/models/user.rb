class User < ActiveRecord::Base
  attr_accessible :name, :email, :default_hourly_rate, :password, :password_confirmation
  has_secure_password

  has_many :time_sheets

  before_save { |user| user.email = email.downcase }

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, 
     uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
     uniqueness: { case_sensitive: false }
  validates :default_hourly_rate, presence: true, numericality: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :password_confirmation, presence: true
end
