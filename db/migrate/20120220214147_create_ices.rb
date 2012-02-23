class CreateIces < ActiveRecord::Migration
  def change
    create_table :ices do |t|
      t.integer :observation_id
      t.integer :thin_ice_lookup_id
      t.integer :thick_ice_lookup_id
      t.float :total_concentration
      t.integer :open_water_lookup_id
      t.timestamps
    end
  end
end
