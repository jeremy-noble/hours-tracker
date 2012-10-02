class Entry < ActiveRecord::Base
  attr_accessible :date, :hours, :project, :hourly_rate
  belongs_to :time_sheet

  validates :date, presence: true
  validates :hours, presence: true, :numericality => { :greater_than => 0, :less_than => 24 }
  validates :time_sheet_id, presence: true
  validates :hourly_rate, numericality: true, allow_blank: true

  default_scope :order => 'date DESC'

end
