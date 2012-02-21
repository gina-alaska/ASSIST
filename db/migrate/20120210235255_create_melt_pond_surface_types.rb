class CreateMeltPondSurfaceTypes < ActiveRecord::Migration
  def change
    create_table :melt_pond_surface_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
