class CreateMeltPonds < ActiveRecord::Migration
  def change
    create_table :melt_ponds do |t|
      t.integer :ice_observation_id
      t.integer :surface_coverage
      t.integer :max_depth_lookup_id
      t.integer :surface_lookup_id
      t.integer :freeboard
      t.integer :pattern_lookup_id
      t.timestamps
    end
  end
end
