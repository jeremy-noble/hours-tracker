class AddHourlyRateToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :hourly_rate, :decimal, :precision => 8, :scale => 2
  end
end
