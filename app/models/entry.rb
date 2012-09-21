class Entry < ActiveRecord::Base
  attr_accessible :date, :hours, :project
  belongs_to :time_sheet

  validates :date, presence: true
  validates :hours, presence: true, :numericality => { :greater_than => 0, :less_than => 24 }
  validates :time_sheet_id, presence: true

  default_scope :order => 'date DESC'

end
