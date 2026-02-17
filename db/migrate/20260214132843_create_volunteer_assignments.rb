class CreateVolunteerAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :volunteer_assignments do |t|
      t.references :volunteer, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.integer :status, null: false, default: 0
      t.decimal :hours_worked, precision: 6, scale: 2
      t.date :date_logged

      t.timestamps
    end

    add_index :volunteer_assignments, [:volunteer_id, :event_id],
              unique: true,
              name: "index_volunteer_assignments_on_volunteer_and_event"

    add_check_constraint :volunteer_assignments,
                         "(hours_worked IS NULL) OR (hours_worked >= 0)",
                         name: "chk_volunteer_assignments_hours_non_negative"
  end
end