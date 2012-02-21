class CreateTopographyTypes < ActiveRecord::Migration
  def change
    create_table :topography_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
