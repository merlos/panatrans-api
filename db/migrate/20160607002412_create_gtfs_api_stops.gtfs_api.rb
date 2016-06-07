# This migration comes from gtfs_api (originally 20140713165323)
class CreateGtfsApiStops < ActiveRecord::Migration
  def change
    create_table :gtfs_api_stops do |t|
      t.string :io_id
      t.string :code
      t.string :name
      t.text :desc
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lon, precision: 10, scale: 6
      t.string :zone_id, null:true #=> fare rules, 
      t.string :url
      t.integer :location_type, default: 0
      t.string :io_parent_station
      t.belongs_to :parent_station, null:true
      t.string :timezone, limit: 64
      t.integer :wheelchair_boarding
      t.integer :vehicle_type

      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_stops, :io_id
    add_index :gtfs_api_stops, :zone_id
    
  end
end
