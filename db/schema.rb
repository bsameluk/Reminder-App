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

ActiveRecord::Schema[7.1].define(version: 2025_01_23_214337) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "reminder_frequency", ["One-Time", "Each day", "Each week", "Each month", "Each 2 minutes", "Each 5 minutes"]
  create_enum "reminder_histories_status", ["Pending", "Done", "Failed", "Canceled"]

  create_table "reminder_histories", force: :cascade do |t|
    t.bigint "reminder_id", null: false
    t.datetime "scheduled_at", null: false
    t.enum "status", default: "Pending", null: false, enum_type: "reminder_histories_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "job_id"
    t.index ["reminder_id"], name: "index_reminder_histories_on_reminder_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "scheduled_at", null: false
    t.decimal "price", precision: 14, scale: 2, null: false
    t.string "currency", limit: 3, null: false
    t.enum "frequency", null: false, enum_type: "reminder_frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone", null: false
  end

  add_foreign_key "reminder_histories", "reminders"
end
