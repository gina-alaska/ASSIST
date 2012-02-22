class RenameLookupTables < ActiveRecord::Migration
  def change
    rename_table :algae_distributions, :algae_distribution_lookups
    rename_table :animal_types, :animal_lookups
    rename_table :biota_types, :biota_lookups
    rename_table :cloud_types, :cloud_lookups
    rename_table :floe_sizes, :floe_size_lookups
    rename_table :ice_discolorations, :ice_discoloration_lookups
    rename_table :ice_field_types, :ice_field_lookups
    rename_table :ice_types, :ice_lookups
    rename_table :melt_pond_max_depths, :melt_pond_max_depth_lookups
    rename_table :melt_pond_patterns, :melt_pond_pattern_lookups
    rename_table :melt_pond_surface_types, :melt_pond_surface_lookups
    rename_table :on_boat_locations, :on_boat_location_lookups
    rename_table :open_water_types, :open_water_lookups
    rename_table :progress_types, :progress_lookups
    rename_table :region_types, :region_lookups
    rename_table :sea_states, :sea_state_lookups
    rename_table :sediment_types, :sediment_lookups
    rename_table :snow_types, :snow_lookups
    rename_table :visibility_types, :visibility_lookups
    rename_table :weather_types, :weather_lookups
  end

end
