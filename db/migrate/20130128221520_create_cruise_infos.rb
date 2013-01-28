class CreateCruiseInfos < ActiveRecord::Migration
  def change
    create_table :cruise_infos do |t|
      t.string :ship
      t.string :season

      t.timestamps
    end
  end
end
