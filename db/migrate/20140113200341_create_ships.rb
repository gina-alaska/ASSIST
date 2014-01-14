class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.integer :observation_id
      t.string :speed
      t.string :heading
      t.string :power
      t.integer :ship_activity_lookup_id

      t.timestamps
    end
  end
end
