class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.datetime :remember_created_at

      t.timestamps
    end

    add_index :users, [ :provider, :uid ], unique: true
  end
end
