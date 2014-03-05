class CreateBiotaDensityLookups < ActiveRecord::Migration
  def change
    create_table :biota_density_lookups do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
