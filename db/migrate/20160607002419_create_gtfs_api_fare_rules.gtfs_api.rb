# This migration comes from gtfs_api (originally 20140713165409)
class CreateGtfsApiFareRules < ActiveRecord::Migration
  def change
    create_table :gtfs_api_fare_rules do |t|
      t.belongs_to :fare
      t.belongs_to :route # => route->route_id 
      t.string :origin_id # => stops->zone_id
      t.string :destination_id # => stops->zone_id
      t.string :contains_id # => stops->zone_id
      
      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_fare_rules, :fare_id
    add_index :gtfs_api_fare_rules, :route_id
    add_index :gtfs_api_fare_rules, :origin_id
    add_index :gtfs_api_fare_rules, :destination_id
    add_index :gtfs_api_fare_rules, :contains_id
    
  end
end
