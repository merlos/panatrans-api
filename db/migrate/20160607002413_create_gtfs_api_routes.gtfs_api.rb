# This migration comes from gtfs_api (originally 20140713165337)
class CreateGtfsApiRoutes < ActiveRecord::Migration
  def change
    create_table :gtfs_api_routes do |t|
      t.string :io_id
      t.belongs_to :agency
      
      t.string :short_name
      t.string :long_name
      t.text :desc
      t.integer :route_type
      t.string :url
      t.string :color, limit: 8 # it is an RGB value, but with length 8, supports ARGB
      t.string :text_color, limit: 8 

      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_routes, :io_id
  end
end
