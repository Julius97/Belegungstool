# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150329143629) do

  create_table "abonnements", force: true do |t|
    t.integer  "user_id"
    t.integer  "court_id"
    t.date     "from_date"
    t.date     "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "playing_time_starts"
    t.datetime "playing_time_ends"
    t.integer  "playing_day",         limit: 255
  end

  create_table "bookings", force: true do |t|
    t.integer  "user_id"
    t.integer  "court_id"
    t.datetime "from_date"
    t.datetime "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courts", force: true do |t|
    t.string   "name"
    t.boolean  "opened"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lesson_cards", force: true do |t|
    t.integer  "user_id"
    t.integer  "initially"
    t.decimal  "remaining"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_lists", force: true do |t|
    t.decimal  "price",      precision: 5, scale: 2
    t.string   "lesson"
    t.datetime "from_time"
    t.datetime "to_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin_permissions"
    t.integer  "club_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mail_address"
    t.string   "password_hash"
    t.string   "password_salt"
  end

end
