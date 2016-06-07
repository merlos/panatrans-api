# This migration comes from gtfs_api (originally 20140713165344)
class CreateGtfsApiTrips < ActiveRecord::Migration
  def change
    create_table :gtfs_api_trips do |t|
      t.string :io_id
      t.belongs_to :route
      
      t.belongs_to :service
      t.string :headsign
      t.string :short_name
      
      t.integer :direction #boolean
      
      t.string :block_id
      t.string :shape_id
      
      t.integer :wheelchair_accesible, default: 0
      t.integer :bikes_allowed, default: 0

      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_trips, :io_id
    add_index :gtfs_api_trips, :block_id
    add_index :gtfs_api_trips, :shape_id
    
  end
end
