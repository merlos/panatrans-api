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

ActiveRecord::Schema.define(version: 20150224163311) do

  create_table "routes", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stop_sequences", force: true do |t|
    t.integer  "sequence"
    t.integer  "trip_id"
    t.integer  "stop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stop_sequences", ["stop_id"], name: "index_stop_sequences_on_stop_id"
  add_index "stop_sequences", ["trip_id"], name: "index_stop_sequences_on_trip_id"

  create_table "stops", force: true do |t|
    t.string   "name"
    t.decimal  "lat",        precision: 10, scale: 6
    t.decimal  "lon",        precision: 10, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", force: true do |t|
    t.string   "headsign"
    t.integer  "route_id"
    t.integer  "direction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["route_id"], name: "index_trips_on_route_id"

end
