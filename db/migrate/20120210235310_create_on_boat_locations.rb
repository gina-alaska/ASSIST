class CreateOnBoatLocations < ActiveRecord::Migration
  def change
    create_table :on_boat_locations do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
