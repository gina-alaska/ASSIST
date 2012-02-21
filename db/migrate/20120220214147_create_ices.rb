class CreateIces < ActiveRecord::Migration
  def change
    create_table :ices do |t|
      t.integer :observation_id
      t.integer :observation_type_id
      t.integer :partial_concentration
      t.integer :ice_type_id
      t.integer :thickness
      t.integer :floe_size_id
      t.integer :topography_id
      t.integer :snow_type_id
      t.integer :snow_thickness
      t.integer :melt_pond_surface_coverage
      t.integer :melt_pond_max_depth_id
      t.integer :melt_pond_surface_type_id
      t.integer :melt_pond_freeboard
      t.integer :melt_pond_pattern_id
      t.integer :biota_frequency_id
      t.integer :sediment_frequency_id

      t.timestamps
    end
  end
end
