class CreateSedimentTypes < ActiveRecord::Migration
  def change
    create_table :sediment_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
