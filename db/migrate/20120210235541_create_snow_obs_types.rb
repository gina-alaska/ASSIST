class CreateSnowObsTypes < ActiveRecord::Migration
  def change
    create_table :snow_obs_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
