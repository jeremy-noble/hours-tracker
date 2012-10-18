class TimeSheet < ActiveRecord::Base
  attr_accessible :paid, :notes
  belongs_to :user
  has_many :entries

  after_initialize :default_values

  validates :user_id, presence: true

  default_scope :order => 'created_at desc'

  def total_hours
    total_hours = 0
    if self.entries
      self.entries.each do |entry|
        total_hours = total_hours + entry.hours
      end
    return total_hours
    end
  end

  def total_cash
    total_cash = 0
    if self.entries
      self.entries.each do |entry|
        total_cash = total_cash + (entry.hours * entry.hourly_rate)
      end
    return total_cash
    end
  end

  private
    def default_values
      self.paid ||= false
    end
end
