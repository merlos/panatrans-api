# This migration comes from gtfs_api (originally 20141004125942)
class CreateGtfsApiFeeds < ActiveRecord::Migration
  def change
    create_table :gtfs_api_feeds do |t|
      t.string :io_id
      t.string :name
      t.string :source_url
      t.string :prefix
      t.integer :version
    
      t.timestamps
    end
    add_index :gtfs_api_feeds, :io_id
  end
end
