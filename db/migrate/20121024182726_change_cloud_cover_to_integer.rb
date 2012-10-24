class ChangeCloudCoverToInteger < ActiveRecord::Migration
  def up
    change_column :clouds, :cover, :integer
  end

  def down
    change_column :clouds, :cover, :float
  end
end
