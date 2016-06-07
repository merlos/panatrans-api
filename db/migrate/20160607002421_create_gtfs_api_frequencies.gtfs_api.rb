# This migration comes from gtfs_api (originally 20140713165429)
class CreateGtfsApiFrequencies < ActiveRecord::Migration
  def change
    create_table :gtfs_api_frequencies do |t|
      t.belongs_to :trip
      t.time :start_time
      t.time :end_time
      t.integer :headway_secs
      t.integer :exact_times

      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_frequencies, :trip_id
  end
end
