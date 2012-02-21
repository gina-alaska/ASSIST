class CreateMeltPondPatterns < ActiveRecord::Migration
  def change
    create_table :melt_pond_patterns do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
