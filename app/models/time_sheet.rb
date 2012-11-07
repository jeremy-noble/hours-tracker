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
      total_hours = self.entries.sum(:hours)
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

  def hourly_only?
    if self.entries
      self.entries.each do |entry|
        if entry.time_sheet.user.default_hourly_rate != entry.hourly_rate
          return false
        end
      end
      # return true if all entries are equal to the default value
      return true
    end
  end

  private
    def default_values
      self.paid ||= false
    end
end
