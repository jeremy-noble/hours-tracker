class Entry < ActiveRecord::Base
  attr_accessible :date, :hours, :project, :time_sheet_id
  belongs_to :time_sheet

  validates :date, presence: true
  validates :hours, presence: true, numericality: true
  validates :time_sheet_id, presence: true

  default_scope :order => 'date desc'

  def nice_date
    self.created_at.strftime("%b %e, %Y")
  end

end
