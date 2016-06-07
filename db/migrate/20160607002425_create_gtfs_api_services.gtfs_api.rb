# This migration comes from gtfs_api (originally 20141012170410)
class CreateGtfsApiServices < ActiveRecord::Migration
  def change
    create_table :gtfs_api_services do |t|
      t.string :io_id
      t.belongs_to :feed, null: false, index: true
    end
    add_index :gtfs_api_services, :io_id
  end
end
