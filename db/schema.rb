# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161020043926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.integer  "business_id"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "type"
    t.boolean  "archived",                     default: false
    t.boolean  "prevent_back_to_back_booking", default: false
    t.index ["business_id"], name: "index_activities_on_business_id", using: :btree
  end

  create_table "booking_reservable_options", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "reservable_option_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["booking_id"], name: "index_booking_reservable_options_on_booking_id", using: :btree
    t.index ["reservable_option_id"], name: "index_booking_reservable_options_on_reservable_option_id", using: :btree
  end

  create_table "bookings", force: :cascade do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.date     "booking_date"
    t.integer  "number_of_players"
    t.string   "options"
    t.integer  "order_id"
    t.integer  "reservable_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["order_id"], name: "index_bookings_on_order_id", using: :btree
    t.index ["reservable_id"], name: "index_bookings_on_reservable_id", using: :btree
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_businesses_on_user_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "activity_id"
    t.index ["activity_id"], name: "index_orders_on_activity_id", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "reservable_options", force: :cascade do |t|
    t.string   "reservable_type"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "reservable_options_availables", force: :cascade do |t|
    t.integer  "reservable_id"
    t.integer  "reservable_option_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["reservable_id"], name: "index_reservable_options_availables_on_reservable_id", using: :btree
    t.index ["reservable_option_id"], name: "index_reservable_options_availables_on_reservable_option_id", using: :btree
  end

  create_table "reservables", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "interval"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "activity_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "maximum_players"
    t.float    "weekday_price"
    t.float    "weekend_price"
    t.boolean  "archived",        default: false
    t.index ["activity_id"], name: "index_reservables_on_activity_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "activities", "businesses"
  add_foreign_key "booking_reservable_options", "bookings"
  add_foreign_key "booking_reservable_options", "reservable_options"
  add_foreign_key "bookings", "orders"
  add_foreign_key "bookings", "reservables"
  add_foreign_key "businesses", "users"
  add_foreign_key "orders", "activities"
  add_foreign_key "orders", "users"
  add_foreign_key "reservable_options_availables", "reservable_options"
  add_foreign_key "reservable_options_availables", "reservables"
  add_foreign_key "reservables", "activities"
end
