# This migration comes from gtfs_api (originally 20140713165435)
class CreateGtfsApiTransfers < ActiveRecord::Migration
  def change
    create_table :gtfs_api_transfers do |t|      
      t.belongs_to :from_stop
      t.belongs_to :to_stop
      
      t.integer :transfer_type
      t.integer :min_transfer_time
      
      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_transfers, :from_stop_id
    add_index :gtfs_api_transfers, :to_stop_id
  end
end
