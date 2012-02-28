class CreateSurfaceTypes < ActiveRecord::Migration
  def change
    create_table :surface_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
