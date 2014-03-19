class CreateBiotaLocationLookups < ActiveRecord::Migration
  def change
    create_table :biota_location_lookups do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
