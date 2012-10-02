class TimeSheet < ActiveRecord::Base
  attr_accessible :paid
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
    return total_hours.to_s
    end
  end

  private
    def default_values
      self.paid ||= false
    end
end
