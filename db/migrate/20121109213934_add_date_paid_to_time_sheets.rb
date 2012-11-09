class AddDatePaidToTimeSheets < ActiveRecord::Migration
  def change
    add_column :time_sheets, :date_paid, :date
  end
end
