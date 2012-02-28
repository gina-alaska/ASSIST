class CreateTopographies < ActiveRecord::Migration
  def change
    create_table :topographies do |t|
      t.integer :topography_lookup_id
      t.integer :ice_observation_id
      t.boolean :old
      t.boolean :consolidated
      t.boolean :snow_covered
      t.float :concentration
      t.float :ridge_height

      t.timestamps
    end
  end
end
