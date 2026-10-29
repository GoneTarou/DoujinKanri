class CreateWeeklyAvailabilities < ActiveRecord::Migration[8.1]
  def change
    create_table :weekly_availabilities do |t|
      t.references :work, null: false, foreign_key: true
      t.integer :weekday, null: false
      t.integer :hours, null: false

      t.timestamps
    end

    add_index :weekly_availabilities, [ :work_id, :weekday ], unique: true

    add_check_constraint :weekly_availabilities,
                         "weekday BETWEEN 0 AND 6",
                         name: "weekly_availabilities_weekday_range"

    add_check_constraint :weekly_availabilities,
                         "hours BETWEEN 0 AND 24",
                         name: "weekly_availabilities_hours_range"
  end
end
