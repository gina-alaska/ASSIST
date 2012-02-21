class CreateCloudTypes < ActiveRecord::Migration
  def change
    create_table :cloud_types do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
