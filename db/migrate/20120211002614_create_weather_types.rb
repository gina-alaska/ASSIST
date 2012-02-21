class CreateWeatherTypes < ActiveRecord::Migration
  def change
    create_table :weather_types do |t|
      t.integer :code
      t.string :name
      t.string :comment

      t.timestamps
    end
  end
end
