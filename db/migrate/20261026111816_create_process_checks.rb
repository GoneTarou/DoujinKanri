class CreateProcessChecks < ActiveRecord::Migration[8.1]
  def change
    create_table :process_checks do |t|
      t.references :production_unit, null: false, foreign_key: true
      t.references :work_process, null: false, foreign_key: true
      t.boolean :checked, null: false, default: false

      t.timestamps
    end

    add_index :process_checks,
              [ :production_unit_id, :work_process_id ],
              unique: true
  end
end
