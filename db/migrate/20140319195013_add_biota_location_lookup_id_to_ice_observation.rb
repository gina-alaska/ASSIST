class AddBiotaLocationLookupIdToIceObservation < ActiveRecord::Migration
  def change
    add_column :ice_observations, :biota_location_lookup_id, :integer
  end
end
