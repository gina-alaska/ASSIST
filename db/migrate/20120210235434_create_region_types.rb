class CreateRegionTypes < ActiveRecord::Migration
  def change
    create_table :region_types do |t|
      t.string :region
      t.string :subregion
      t.integer :code

      t.timestamps
    end
  end
end
