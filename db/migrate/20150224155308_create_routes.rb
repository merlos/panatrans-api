class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :name

      t.timestamps
    end
  end
end
