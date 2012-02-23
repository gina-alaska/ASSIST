class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.integer :cruise_id
      t.date :obs_datetime
      t.string :latitude
      t.string :longitude
      t.string :hexcode

      t.timestamps
    end
  end
end
