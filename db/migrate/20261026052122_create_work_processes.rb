class CreateWorkProcesses < ActiveRecord::Migration[8.1]
  def change
    create_table :work_processes do |t|
      t.references :work, null: false, foreign_key: true
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_index :work_processes, [ :work_id, :position ], unique: true
  end
end
