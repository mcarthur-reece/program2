class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string  :title, null: false
      t.text    :description, null: false
      t.string  :location, null: false
      t.date    :event_date, null: false
      t.time    :start_time, null: false
      t.time    :end_time, null: false
      t.integer :required_number_of_volunteers, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :events, :event_date
    add_index :events, :status
  end
end