class AddBiotaDensityLookupIdToIceObservations < ActiveRecord::Migration
  def change
    add_column :ice_observations, :biota_density_lookup_id, :integer
  end
end
