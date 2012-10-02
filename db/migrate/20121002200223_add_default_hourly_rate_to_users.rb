class AddDefaultHourlyRateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_hourly_rate, :decimal, :precision => 8, :scale => 2
  end
end
