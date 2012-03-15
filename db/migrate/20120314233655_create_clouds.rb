class CreateClouds < ActiveRecord::Migration
  def change
    create_table :clouds do |t|
      t.float :cover
      t.integer :height
      t.integer :cloud_lookup_id
      t.integer :meteorology_id
      t.string :cloud_type
      t.timestamps
    end
  end
end
