class CreateSnowTypes < ActiveRecord::Migration
  def change
    create_table :snow_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
