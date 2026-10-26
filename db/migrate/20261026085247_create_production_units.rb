class CreateProductionUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :production_units do |t|
      t.references :work, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end

    add_index :production_units, [ :work_id, :position ], unique: true
  end
end
