class CreateMeltPondMaxDepths < ActiveRecord::Migration
  def change
    create_table :melt_pond_max_depths do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
