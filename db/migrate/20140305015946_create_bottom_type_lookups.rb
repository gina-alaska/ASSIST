class CreateBottomTypeLookups < ActiveRecord::Migration
  def change
    create_table :bottom_type_lookups do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
