class CreateWorks < ActiveRecord::Migration[8.1]
  def change
    create_table :works do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :work_type
      t.integer :total_quantity
      t.date :start_date
      t.date :deadline

      t.timestamps
    end
  end
end
