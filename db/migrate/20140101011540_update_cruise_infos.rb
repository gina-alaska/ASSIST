class UpdateCruiseInfos < ActiveRecord::Migration
  def change
    add_column :cruise_infos, :purpose, :string
    add_column :cruise_infos, :chief_scientist, :string
    add_column :cruise_infos, :captain, :string
    add_column :cruise_infos, :begin_at, :string
    add_column :cruise_infos, :end_at, :string
    remove_column :cruise_infos, :season
  end
end
