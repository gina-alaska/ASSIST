class CreateMeteorologies < ActiveRecord::Migration
  def change
    create_table :meteorologies do |t|
      t.integer :visibility_lookup_id
      t.integer :weather_lookup_id
      t.integer :cloud_lookup_id
      t.float :cloud_cover
      t.integer :cloud_height

      t.timestamps
    end

    remove_column :observations, :cloud_cover
    remove_column :observations, :visibility_lookup_id
    remove_column :observations, :cloud_lookup_id
    remove_column :observations, :cloud_height
    remove_column :observations, :weather_lookup_id

  end
end
