class AddFieldsToMeteorology < ActiveRecord::Migration
  def change
    add_column :meteorologies, :total_cloud_cover, :integer
    add_column :meteorologies, :wind_speed, :integer
    add_column :meteorologies, :wind_direction, :string
    add_column :meteorologies, :air_temperature, :integer
    add_column :meteorologies, :water_temperature, :integer
    add_column :meteorologies, :relative_humidity, :integer
    add_column :meteorologies, :air_pressure, :integer
  end
end
