# This migration comes from gtfs_api (originally 20140713165307)
class CreateGtfsApiAgencies < ActiveRecord::Migration
  def change
    create_table :gtfs_api_agencies do |t|
      t.string :io_id, limit: 128
      t.string :name
      t.string :url
      t.string :timezone, limit: 64
      t.string :lang, limit:2
      t.string :phone, limit: 24
      t.string :fare_url

      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_agencies, :io_id
  end
end
