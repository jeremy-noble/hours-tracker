class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :time_sheet_id
      t.datetime :date
      t.decimal :hours, :precision => 4, :scale => 2
      t.string :project

      t.timestamps
    end
  end
end
