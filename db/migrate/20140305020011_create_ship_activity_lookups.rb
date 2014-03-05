class CreateShipActivityLookups < ActiveRecord::Migration
  def change
    create_table :ship_activity_lookups do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
