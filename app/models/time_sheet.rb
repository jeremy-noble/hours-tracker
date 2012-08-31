class TimeSheet < ActiveRecord::Base
  attr_accessible :paid, :user_id
  belongs_to :user
  has_many :entries

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

end
