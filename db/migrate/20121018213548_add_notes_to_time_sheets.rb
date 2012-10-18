class AddNotesToTimeSheets < ActiveRecord::Migration
  def change
    add_column :time_sheets, :notes, :text
  end
end
