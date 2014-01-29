class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.integer :observation_id
      t.integer :speed
      t.integer :heading
      t.integer :power
      t.integer :ship_activity_lookup_id

      t.timestamps
    end
  end
end
