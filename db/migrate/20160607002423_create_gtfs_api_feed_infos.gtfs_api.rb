# This migration comes from gtfs_api (originally 20140713165440)
class CreateGtfsApiFeedInfos < ActiveRecord::Migration
  def change
    create_table :gtfs_api_feed_infos do |t|
      t.string  :publisher_name, limit:128
      t.string  :publisher_url, limit: 128
      t.string  :lang, limit: 30
      t.date    :start_date
      t.date    :end_date
      t.string  :version, limit: 24
      
      t.belongs_to :feed, null: false, index: true
      t.timestamps      
      
    end
    
  end
end
