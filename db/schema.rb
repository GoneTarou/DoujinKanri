# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_28_100745) do
  create_table "process_checks", force: :cascade do |t|
    t.integer "production_unit_id", null: false
    t.integer "work_process_id", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["production_unit_id", "work_process_id"], name: "index_process_checks_on_production_unit_id_and_work_process_id", unique: true
    t.index ["production_unit_id"], name: "index_process_checks_on_production_unit_id"
    t.index ["work_process_id"], name: "index_process_checks_on_work_process_id"
  end

  create_table "production_units", force: :cascade do |t|
    t.integer "work_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id", "position"], name: "index_production_units_on_work_id_and_position", unique: true
    t.index ["work_id"], name: "index_production_units_on_work_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "weekly_availabilities", force: :cascade do |t|
    t.integer "work_id", null: false
    t.integer "weekday", null: false
    t.integer "hours", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id", "weekday"], name: "index_weekly_availabilities_on_work_id_and_weekday", unique: true
    t.index ["work_id"], name: "index_weekly_availabilities_on_work_id"
    t.check_constraint "hours BETWEEN 0 AND 24", name: "weekly_availabilities_hours_range"
    t.check_constraint "weekday BETWEEN 0 AND 6", name: "weekly_availabilities_weekday_range"
  end

  create_table "work_processes", force: :cascade do |t|
    t.integer "work_id", null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id", "position"], name: "index_work_processes_on_work_id_and_position", unique: true
    t.index ["work_id"], name: "index_work_processes_on_work_id"
  end

  create_table "works", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.string "work_type"
    t.integer "total_quantity"
    t.date "start_date"
    t.date "deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "process_checks", "production_units"
  add_foreign_key "process_checks", "work_processes"
  add_foreign_key "production_units", "works"
  add_foreign_key "weekly_availabilities", "works"
  add_foreign_key "work_processes", "works"
  add_foreign_key "works", "users"
end
