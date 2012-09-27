class AddUuidToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :uuid, :string
  end
end
