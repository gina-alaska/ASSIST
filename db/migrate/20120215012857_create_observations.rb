class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.integer :cruise_id
      t.date :obs_datetime
      t.string :latitude
      t.string :longitude
      t.float :sea_ice_concentration
      t.integer :open_water_type_id
      t.integer :thin_ice_type_id
      t.integer :thick_ice_type_id
      t.integer :visibility_id
      t.string :cloud_cover
      t.integer :cloud_height
      t.integer :cloud_type_id
      t.integer :weather_id

      t.timestamps
    end
  end
end
