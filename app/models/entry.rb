class Entry < ActiveRecord::Base
  attr_accessible :date, :hours, :project, :time_sheet_id
  belongs_to :time_sheet
end
