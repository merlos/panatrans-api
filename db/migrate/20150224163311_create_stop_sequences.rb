class CreateStopSequences < ActiveRecord::Migration
  def change
    create_table :stop_sequences do |t|
      t.integer :sequence
      t.belongs_to :trip, index: true
      t.belongs_to :stop, index: true

      t.timestamps
    end
  end
end
