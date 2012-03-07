class ChangeObsDatetimeToDatetimeInObservations < ActiveRecord::Migration
  def up
    change_column :observations, :obs_datetime, :datetime
  end

  def down
    change_column :observations, :obs_datetime, :date
  end
end
