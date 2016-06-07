# This migration comes from gtfs_api (originally 20140713165404)
class CreateGtfsApiFareAttributes < ActiveRecord::Migration
  def change
    create_table :gtfs_api_fare_attributes do |t|
      t.string :io_id
      t.belongs_to :agency
      t.decimal :price
      t.string :currency_type, limit: 3
      t.integer :payment_method
      t.integer :transfers
      t.integer :transfer_duration
      
      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_fare_attributes, :io_id
    add_index :gtfs_api_fare_attributes, :agency_id
  end
  
end
