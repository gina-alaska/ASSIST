class CreateIceObsTypes < ActiveRecord::Migration
  def change
    create_table :ice_obs_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
