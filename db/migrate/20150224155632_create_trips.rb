class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :headsign
      t.belongs_to :route
      t.integer :direction

      t.timestamps
    end
    add_index :trips, :route_id 
  end
end
