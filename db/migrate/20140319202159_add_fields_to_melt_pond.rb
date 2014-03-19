class AddFieldsToMeltPond < ActiveRecord::Migration
  def change
    add_column :melt_ponds, :dried_ice, :boolean
    add_column :melt_ponds, :rotten_ice, :boolean
  end
end
