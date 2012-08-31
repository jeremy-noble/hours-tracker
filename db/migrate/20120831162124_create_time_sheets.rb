class CreateTimeSheets < ActiveRecord::Migration
  def change
    create_table :time_sheets do |t|
      t.integer :user_id
      t.boolean :paid

      t.timestamps
    end
  end
end
