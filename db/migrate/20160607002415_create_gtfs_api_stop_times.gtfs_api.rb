# This migration comes from gtfs_api (originally 20140713165351)
class CreateGtfsApiStopTimes < ActiveRecord::Migration
  def change
    create_table :gtfs_api_stop_times do |t|
      t.belongs_to :trip
      t.datetime :arrival_time
      t.datetime :departure_time
      t.belongs_to :stop
      t.integer :stop_sequence
      t.string :stop_headsign
      t.integer :pickup_type, default: 0 # Regularly scheduled pick up
      t.integer :drop_off_type, default: 0 #Regularly scheduled drop off
      t.decimal :dist_traveled

      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_stop_times, :trip_id
    add_index :gtfs_api_stop_times, :stop_id
  end
end
