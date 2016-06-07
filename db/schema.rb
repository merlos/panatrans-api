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

ActiveRecord::Schema.define(version: 20160607002425) do

  create_table "gtfs_api_agencies", force: :cascade do |t|
    t.string   "io_id",      limit: 128
    t.string   "name"
    t.string   "url"
    t.string   "timezone",   limit: 64
    t.string   "lang",       limit: 2
    t.string   "phone",      limit: 24
    t.string   "fare_url"
    t.integer  "feed_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_agencies", ["feed_id"], name: "index_gtfs_api_agencies_on_feed_id"
  add_index "gtfs_api_agencies", ["io_id"], name: "index_gtfs_api_agencies_on_io_id"

  create_table "gtfs_api_calendar_dates", force: :cascade do |t|
    t.integer  "service_id"
    t.date     "date"
    t.integer  "exception_type"
    t.integer  "feed_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_calendar_dates", ["feed_id"], name: "index_gtfs_api_calendar_dates_on_feed_id"
  add_index "gtfs_api_calendar_dates", ["service_id"], name: "index_gtfs_api_calendar_dates_on_service_id"

  create_table "gtfs_api_calendars", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "monday"
    t.integer  "tuesday"
    t.integer  "wednesday"
    t.integer  "thursday"
    t.integer  "friday"
    t.integer  "saturday"
    t.integer  "sunday"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "feed_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_calendars", ["feed_id"], name: "index_gtfs_api_calendars_on_feed_id"
  add_index "gtfs_api_calendars", ["service_id"], name: "index_gtfs_api_calendars_on_service_id"

  create_table "gtfs_api_fare_attributes", force: :cascade do |t|
    t.string   "io_id"
    t.integer  "agency_id"
    t.decimal  "price"
    t.string   "currency_type",     limit: 3
    t.integer  "payment_method"
    t.integer  "transfers"
    t.integer  "transfer_duration"
    t.integer  "feed_id",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_fare_attributes", ["agency_id"], name: "index_gtfs_api_fare_attributes_on_agency_id"
  add_index "gtfs_api_fare_attributes", ["feed_id"], name: "index_gtfs_api_fare_attributes_on_feed_id"
  add_index "gtfs_api_fare_attributes", ["io_id"], name: "index_gtfs_api_fare_attributes_on_io_id"

  create_table "gtfs_api_fare_rules", force: :cascade do |t|
    t.integer  "fare_id"
    t.integer  "route_id"
    t.string   "origin_id"
    t.string   "destination_id"
    t.string   "contains_id"
    t.integer  "feed_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_fare_rules", ["contains_id"], name: "index_gtfs_api_fare_rules_on_contains_id"
  add_index "gtfs_api_fare_rules", ["destination_id"], name: "index_gtfs_api_fare_rules_on_destination_id"
  add_index "gtfs_api_fare_rules", ["fare_id"], name: "index_gtfs_api_fare_rules_on_fare_id"
  add_index "gtfs_api_fare_rules", ["feed_id"], name: "index_gtfs_api_fare_rules_on_feed_id"
  add_index "gtfs_api_fare_rules", ["origin_id"], name: "index_gtfs_api_fare_rules_on_origin_id"
  add_index "gtfs_api_fare_rules", ["route_id"], name: "index_gtfs_api_fare_rules_on_route_id"

  create_table "gtfs_api_feed_infos", force: :cascade do |t|
    t.string   "publisher_name", limit: 128
    t.string   "publisher_url",  limit: 128
    t.string   "lang",           limit: 30
    t.date     "start_date"
    t.date     "end_date"
    t.string   "version",        limit: 24
    t.integer  "feed_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_feed_infos", ["feed_id"], name: "index_gtfs_api_feed_infos_on_feed_id"

  create_table "gtfs_api_feeds", force: :cascade do |t|
    t.string   "io_id"
    t.string   "name"
    t.string   "source_url"
    t.string   "prefix"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_feeds", ["io_id"], name: "index_gtfs_api_feeds_on_io_id"

  create_table "gtfs_api_frequencies", force: :cascade do |t|
    t.integer  "trip_id"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "headway_secs"
    t.integer  "exact_times"
    t.integer  "feed_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_frequencies", ["feed_id"], name: "index_gtfs_api_frequencies_on_feed_id"
  add_index "gtfs_api_frequencies", ["trip_id"], name: "index_gtfs_api_frequencies_on_trip_id"

  create_table "gtfs_api_routes", force: :cascade do |t|
    t.string   "io_id"
    t.integer  "agency_id"
    t.string   "short_name"
    t.string   "long_name"
    t.text     "desc"
    t.integer  "route_type"
    t.string   "url"
    t.string   "color",      limit: 8
    t.string   "text_color", limit: 8
    t.integer  "feed_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_routes", ["feed_id"], name: "index_gtfs_api_routes_on_feed_id"
  add_index "gtfs_api_routes", ["io_id"], name: "index_gtfs_api_routes_on_io_id"

  create_table "gtfs_api_services", force: :cascade do |t|
    t.string  "io_id"
    t.integer "feed_id", null: false
  end

  add_index "gtfs_api_services", ["feed_id"], name: "index_gtfs_api_services_on_feed_id"
  add_index "gtfs_api_services", ["io_id"], name: "index_gtfs_api_services_on_io_id"

  create_table "gtfs_api_shapes", force: :cascade do |t|
    t.string   "io_id"
    t.decimal  "pt_lat",        precision: 10, scale: 6
    t.decimal  "pt_lon",        precision: 10, scale: 6
    t.integer  "pt_sequence"
    t.decimal  "dist_traveled"
    t.integer  "feed_id",                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_shapes", ["feed_id"], name: "index_gtfs_api_shapes_on_feed_id"
  add_index "gtfs_api_shapes", ["io_id"], name: "index_gtfs_api_shapes_on_io_id"

  create_table "gtfs_api_stop_times", force: :cascade do |t|
    t.integer  "trip_id"
    t.datetime "arrival_time"
    t.datetime "departure_time"
    t.integer  "stop_id"
    t.integer  "stop_sequence"
    t.string   "stop_headsign"
    t.integer  "pickup_type",    default: 0
    t.integer  "drop_off_type",  default: 0
    t.decimal  "dist_traveled"
    t.integer  "feed_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_stop_times", ["feed_id"], name: "index_gtfs_api_stop_times_on_feed_id"
  add_index "gtfs_api_stop_times", ["stop_id"], name: "index_gtfs_api_stop_times_on_stop_id"
  add_index "gtfs_api_stop_times", ["trip_id"], name: "index_gtfs_api_stop_times_on_trip_id"

  create_table "gtfs_api_stops", force: :cascade do |t|
    t.string   "io_id"
    t.string   "code"
    t.string   "name"
    t.text     "desc"
    t.decimal  "lat",                            precision: 10, scale: 6
    t.decimal  "lon",                            precision: 10, scale: 6
    t.string   "zone_id"
    t.string   "url"
    t.integer  "location_type",                                           default: 0
    t.string   "io_parent_station"
    t.integer  "parent_station_id"
    t.string   "timezone",            limit: 64
    t.integer  "wheelchair_boarding"
    t.integer  "vehicle_type"
    t.integer  "feed_id",                                                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_stops", ["feed_id"], name: "index_gtfs_api_stops_on_feed_id"
  add_index "gtfs_api_stops", ["io_id"], name: "index_gtfs_api_stops_on_io_id"
  add_index "gtfs_api_stops", ["zone_id"], name: "index_gtfs_api_stops_on_zone_id"

  create_table "gtfs_api_transfers", force: :cascade do |t|
    t.integer  "from_stop_id"
    t.integer  "to_stop_id"
    t.integer  "transfer_type"
    t.integer  "min_transfer_time"
    t.integer  "feed_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_transfers", ["feed_id"], name: "index_gtfs_api_transfers_on_feed_id"
  add_index "gtfs_api_transfers", ["from_stop_id"], name: "index_gtfs_api_transfers_on_from_stop_id"
  add_index "gtfs_api_transfers", ["to_stop_id"], name: "index_gtfs_api_transfers_on_to_stop_id"

  create_table "gtfs_api_trips", force: :cascade do |t|
    t.string   "io_id"
    t.integer  "route_id"
    t.integer  "service_id"
    t.string   "headsign"
    t.string   "short_name"
    t.integer  "direction"
    t.string   "block_id"
    t.string   "shape_id"
    t.integer  "wheelchair_accesible", default: 0
    t.integer  "bikes_allowed",        default: 0
    t.integer  "feed_id",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_api_trips", ["block_id"], name: "index_gtfs_api_trips_on_block_id"
  add_index "gtfs_api_trips", ["feed_id"], name: "index_gtfs_api_trips_on_feed_id"
  add_index "gtfs_api_trips", ["io_id"], name: "index_gtfs_api_trips_on_io_id"
  add_index "gtfs_api_trips", ["shape_id"], name: "index_gtfs_api_trips_on_shape_id"

end
