class ChangeIceObservationPartialConcentrationToInteger < ActiveRecord::Migration

  def up
    change_column :ice_observations, :partial_concentration, :integer
  end

  def down
    change_column :ice_observations, :partial_concentration, :float
  end
end
