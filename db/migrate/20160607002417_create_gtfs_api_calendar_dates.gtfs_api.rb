# This migration comes from gtfs_api (originally 20140713165400)
class CreateGtfsApiCalendarDates < ActiveRecord::Migration
  def change
    create_table :gtfs_api_calendar_dates do |t|
      t.belongs_to :service
      t.date :date
      t.integer :exception_type
      
      t.belongs_to :feed, null: false, index: true
      t.timestamps
    end
    add_index :gtfs_api_calendar_dates, :service_id
  end
end
