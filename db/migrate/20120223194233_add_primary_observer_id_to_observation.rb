class AddPrimaryObserverIdToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :primary_observer_id, :integer

  end
end
