class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :default_hourly_rate, :password, :password_confirmation
  has_secure_password

  has_many :time_sheets

  before_save { |user| user.email = email.downcase }

  validates :first_name, presence: true
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
     uniqueness: { case_sensitive: false }
  validates :default_hourly_rate, presence: true, numericality: true
  validates :password, presence: true, length: { minimum: 5 }, :on => :create
  validates :password_confirmation, presence: true, :on => :create
end
