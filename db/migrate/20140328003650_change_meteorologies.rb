class ChangeMeteorologies < ActiveRecord::Migration
  def up
    change_column :meteorologies, :air_temperature, :float
    change_column :meteorologies, :water_temperature, :float
  end

  def down
    change_column :meteorologies, :air_temperature, :integer
    change_column :meteorologies, :water_temperature, :integer
  end
end
