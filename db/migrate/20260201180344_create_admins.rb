class CreateVolunteers < ActiveRecord::Migration[8.1]
  def change
    create_table :volunteers do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.text :address
      t.text :skills_interests
      t.decimal :total_hours, precision: 8, scale: 2, default: 0.0

      t.timestamps
    end
    
    add_index :volunteers, :username, unique: true
    add_index :volunteers, :email, unique: true
  end
end