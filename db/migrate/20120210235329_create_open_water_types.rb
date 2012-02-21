class CreateOpenWaterTypes < ActiveRecord::Migration
  def change
    create_table :open_water_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
