class CreateIceObservations < ActiveRecord::Migration
  def change
    create_table :ice_observations do |t|
      t.integer :observation_id
      t.integer :partial_concentration
      t.integer :ice_lookup_id
      t.integer :thickness
      t.integer :floe_size_lookup_id
      t.integer :snow_lookup_id
      t.integer :snow_thickness
      t.integer :biota_lookup_id
      t.integer :sediment_lookup_id
      t.timestamps
    end
  end
end
